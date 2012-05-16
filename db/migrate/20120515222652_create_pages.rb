class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :html, :limit => 5.megabytes
      t.timestamps
    end
  end
end
