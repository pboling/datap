# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :page_views do # rubocop:disable Rails/CreateTableWithTimestamps
      primary_key :id
      String :url, null: false
      String :referrer
      String :digest
      column :created_at, :timestamp, null: false
    end
  end
end
