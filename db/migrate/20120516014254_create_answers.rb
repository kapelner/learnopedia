class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.text :answer_text
      t.string :youtube_link
      t.timestamps
    end
  end
end
