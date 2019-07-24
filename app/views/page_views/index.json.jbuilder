# frozen_string_literal: true

json.array! @page_views, partial: 'page_views/page_view', as: :page_view
