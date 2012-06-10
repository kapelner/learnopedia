class ChangePrereqUrlUnique < ActiveRecord::Migration
  def change
    change_column :prerequisites, :url, :string, :limit => 255
    add_index :prerequisites, :url, :unique => true
  end
end
