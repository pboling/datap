# frozen_string_literal: true

# Wraps a customized internal @hash to facilitate building the set of top urls and top referrers
class TopTracker
  delegate :[], :[]=, :keys, :merge, :empty?, :to_h, to: :@hash

  def initialize(size)
    @size = size
    @hash = Hash.new { |h, k| h[k] = [] }
  end

  def complete?(viewed_on)
    return false unless @size

    self[viewed_on].length >= @size
  end

  def add_page_views(viewed_on, page_views_for_day)
    return self if page_views_for_day.blank?

    list = @size ? ListFiller.new(page_views_for_day, size: @size).list : page_views_for_day
    self[viewed_on].concat(list)
    self
  end

  def add_top_referrers(viewed_on, top_referrers, num_referrers) # rubocop:disable Metrics/AbcSize
    self[viewed_on].map! do |page_view|
      referrers = top_referrers[viewed_on].select { |pv| pv[:url] == page_view.url }
      refs = referrers.sort_by! { |pv| pv[:visits] }.reverse.first(num_referrers)
      page_view.to_h.merge(
        referrers: refs.map { |pv| { url: pv[:referrer], visits: pv[:visits] } }
      )
    end
    self
  end
end
