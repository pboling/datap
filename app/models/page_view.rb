# frozen_string_literal: true

class PageView < Sequel::Model
  TOP_URLS = -> (days_ago) do
    <<~SQL
      SELECT
        "page_views"."url" AS url
        , "page_views"."created_at"::date AS viewed_on
        , COUNT(*) as visits
      FROM "page_views"
      WHERE
        -- MORE RECENT THAN X DAYS AGO
        "page_views"."created_at"::date >= (SELECT cast(date_trunc('day', CURRENT_DATE - INTERVAL '#{days_ago} days') AS date))

      GROUP BY
        url
        , viewed_on
      ORDER BY
        viewed_on DESC
        , visits DESC;
    SQL
  end

  # TODO: test alternate SQL approaches for performance gains
  # 1. Attempt to move the 5 days filter into the inner select
  # 2. Attempt a partition window over the group
  # 3. Attempt a lateral self join
  TOP_REFERRERS = -> (days_ago) do
    <<~SQL
      SELECT * FROM (
        SELECT
          url
          , referrer
          , created_at::date as viewed_on
          , COUNT(*) as visits
        FROM page_views
        GROUP BY 
          url
          , referrer
          , created_at::date
      ) temp
      WHERE
        -- MORE RECENT THAN X DAYS AGO
        viewed_on >= (SELECT cast(date_trunc('day', CURRENT_DATE - INTERVAL '#{days_ago} days') AS date))
      ORDER BY visits DESC;
    SQL
  end

  class << self
    # The end-user should be able to access a REST endpoint in your application in
    #   order to retrieve the number of page views per URL, grouped by day, for the past 5 days.
    #
    # returns data in the format:
    #   { '2017-01-01' : [ { 'url': 'http://apple.com', 'visits': 100 } ] }
    def top_urls(days = 5)
      by_visits_for_days(days).each do |page_views_for_day|
        page_views_for_day.map(&:to_h)
      end
    end

    # Your end-users should be able to retrieve the top 5 referrers for the top 10
    #   URLs grouped by day, for the past 5 days, via a REST endpoint.
    #
    # returns data in the format:
    # {
    #   '2017-01-01' : [
    #     {
    #       'url': 'http://apple.com',
    #       'visits': 100,
    #       'referrers': [ { 'url': 'http://store.apple.com/us', 'visits': 10 } ]
    #     }
    #   ]
    # }
    def top_referrers(days = 5, num_referrers = 5)
      top_10_urls_per_day = TopTracker.new(10)
      top_refs = top_referrers_by_viewed_on(days)
      by_visits_for_days(days).each do |viewed_on, page_views_for_day|
        next if top_10_urls_per_day.complete?(viewed_on)

        top_10_urls_per_day.add_page_views(viewed_on, page_views_for_day)
        # at this point top_10_urls_per_day is like
        # {
        #   '2019-07-16' => [#<PageView>,#<PageView>, ..., #<PageView>],
        #   '2019-07-17' => [#<PageView>,#<PageView>, ..., #<PageView>],
        #   ...
        # } where each PageView is one of the top 10 URLs visited that day
        top_10_urls_per_day.add_top_referrers(viewed_on, top_refs, num_referrers)
      end
      top_10_urls_per_day.to_h
    end

    def by_visits_for_days(days, &block)
      grouped = top_urls_by_viewed_on(days)
      return grouped unless block_given?

      grouped.map.each_with_object({}) do |(viewed_on, page_views_for_day), memo|
        memo[viewed_on] = yield(page_views_for_day)
      end
    end

    def top_urls_by_viewed_on(days)
      fetch(TOP_URLS.call(days)).all.group_by { |d| d[:viewed_on].to_s(:dashed_date) }
    end

    def top_referrers_by_viewed_on(days)
      fetch(TOP_REFERRERS.call(days)).all.group_by { |d| d[:viewed_on].to_s(:dashed_date) }
    end
  end

  def to_h
    {
      url: url,
      # This is tightly bound to a specific query that provides a "visits" count
      visits: self[:visits]
    }
  end
end
