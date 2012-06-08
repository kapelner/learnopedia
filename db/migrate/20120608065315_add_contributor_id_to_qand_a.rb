class AddContributorIdToQandA < ActiveRecord::Migration
  def change
    add_column :questions, :contributor_id, :integer
    add_column :answers, :contributor_id, :integer
  end
end
