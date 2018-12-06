class AddBudgetDelegateOnlyToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :budget_delegate_only, :boolean, default: false
  end
end
