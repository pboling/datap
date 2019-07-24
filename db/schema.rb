Sequel.migration do
  change do
    create_table(:page_views) do
      primary_key :id
      column :url, "text"
      column :referrer, "text"
      column :digest, "text"
      column :created_at, "timestamp without time zone"
    end
    
    create_table(:schema_migrations) do
      column :filename, "text", :null=>false
      
      primary_key [:filename]
    end
  end
end
Sequel.migration do
  change do
    self << "SET search_path TO \"$user\", public"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20190724054917_create_page_views.rb')"
  end
end
