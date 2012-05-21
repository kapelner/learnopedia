class PrereqsHaveAndBelongToManyPages < ActiveRecord::Migration
  def up
    remove_column :prerequisites, :page_id
    create_table :pages_prerequisites, :id => false do |t|
      t.integer :prerequisite_id
      t.integer :page_id
    end
  end

  def down
    add_column :prerequisites, :page_id, :integer
    drop_table :pages_prerequisites
  end
end
