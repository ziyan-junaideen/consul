class AddIdeasAndFormationDescriptionToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :description_ideas_posting, :text
    add_column :budgets, :description_project_forming, :text
  end
end
