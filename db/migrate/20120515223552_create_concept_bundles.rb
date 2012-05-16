class CreateConceptBundles < ActiveRecord::Migration
  def change
    create_table :concept_bundles do |t|
      t.integer :page_id
      t.integer :string_index
      t.integer :user_id
      t.timestamps
    end
  end
end
