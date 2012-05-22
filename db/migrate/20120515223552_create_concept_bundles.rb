class CreateConceptBundles < ActiveRecord::Migration
  def change
    create_table :concept_bundles do |t|
      t.integer :page_id
      t.string :title, :limit => 760
      t.integer :html_span_id
      t.integer :contributor_id
      t.timestamps
    end
  end
end
