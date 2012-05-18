class CreatePrerequisites < ActiveRecord::Migration
  def change
    create_table :prerequisites do |t|
      t.integer :page_id
      t.string :title
      t.string :url
      t.timestamps
    end
    add_index :prerequisites, :page_id
  end
end
