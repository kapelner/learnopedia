class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :concept_bundle_id
      t.text :question_text
      t.string :difficulty_level, :limit => 1
      t.timestamps
    end
  end
end
