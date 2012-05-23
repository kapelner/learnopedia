class AddWikiNameToPages < ActiveRecord::Migration
  def change
    add_column :pages, :wiki_name, :string, :limit => 760
  end
end
