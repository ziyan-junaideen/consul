class AddTitleToBudgetPhases < ActiveRecord::Migration
  def change
    add_column :budget_phases, :title, :string
  end
end
