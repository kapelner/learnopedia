class CreateConceptVideos < ActiveRecord::Migration
  def change
    create_table :concept_videos do |t|
      t.integer :concept_bundle_id
      t.text :description
      t.string :video
      t.timestamps
    end
  end
end
