class AddVarietyToBudgetInvestments < ActiveRecord::Migration
  def change
    add_column :budget_investments, :variety, :integer, default: 0
  end
end
