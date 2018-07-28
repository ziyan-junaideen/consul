class AddIdeasAndFormationDescriptionToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :description_ideas, :text
    add_column :budgets, :description_formation, :text
  end
end
