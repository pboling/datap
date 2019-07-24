class CreatePageViews < ActiveRecord::Migration[5.2]
  def change
    create_table :page_views do |t|
      t.string :url
      t.string :referrer
      t.string :hash
      t.datetime :created_at, null: false
    end
  end
end
