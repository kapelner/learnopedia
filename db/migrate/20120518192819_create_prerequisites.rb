class CreatePrerequisites < ActiveRecord::Migration
  def change
    create_table :prerequisites do |t|
      t.string :title
      t.string :url
      t.timestamps
    end
  end
end
