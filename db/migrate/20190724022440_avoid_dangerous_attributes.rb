class AvoidDangerousAttributes < ActiveRecord::Migration[5.2]
  def change
    rename_column :page_views, :hash, :digest
  end
end
