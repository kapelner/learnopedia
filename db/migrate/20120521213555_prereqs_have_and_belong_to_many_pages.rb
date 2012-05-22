class PrereqsHaveAndBelongToManyPages < ActiveRecord::Migration
  def change
    create_table :pages_prerequisites, :id => false do |t|
      t.integer :prerequisite_id
      t.integer :page_id
    end
    add_index :pages_prerequisites, :prerequisite_id
    add_index :pages_prerequisites, :page_id
  end
end