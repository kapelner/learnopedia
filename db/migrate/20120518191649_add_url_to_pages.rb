class AddUrlToPages < ActiveRecord::Migration
  def change
    add_column :pages, :url, :string, :limit => 760
    add_index :pages, :url, :unique => true
  end
end
