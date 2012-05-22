class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :html, :limit => 5.megabytes
      t.string :url, :limit => 760
      t.timestamps
    end
    add_index :pages, :url, :unique => true
  end
end
