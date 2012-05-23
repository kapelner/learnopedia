class AddHashSetOfIDsToConceptBundles < ActiveRecord::Migration
  def change
    remove_column :concept_bundles, :html_span_id
    add_column :concept_bundles, :bundle_elements_hash, :text
  end
end
