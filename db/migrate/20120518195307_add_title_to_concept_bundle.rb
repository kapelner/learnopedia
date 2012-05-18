class AddTitleToConceptBundle < ActiveRecord::Migration
  def change
    add_column :concept_bundles, :title, :string
  end
end
