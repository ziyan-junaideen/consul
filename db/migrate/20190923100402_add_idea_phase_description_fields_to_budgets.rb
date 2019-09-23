class AddIdeaPhaseDescriptionFieldsToBudgets < ActiveRecord::Migration[5.0]
  def change
    add_column :budgets, :description_ideas_posting, :text
    add_column :budgets, :description_project_forming, :text
  end
end
