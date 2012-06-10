class QuestionsHaveAndBelongToManyConceptBundles < ActiveRecord::Migration
  def change
    create_table :concept_bundles_questions, :id => false do |t|
      t.integer :concept_bundle_id
      t.integer :question_id
    end    
    add_index :concept_bundles_questions, :concept_bundle_id
    add_index :concept_bundles_questions, :question_id
#    remove_column :questions, :concept_bundle_id
  end
end
