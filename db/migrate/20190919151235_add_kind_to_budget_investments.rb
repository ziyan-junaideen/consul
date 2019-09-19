class AddKindToBudgetInvestments < ActiveRecord::Migration[5.0]
  def change
    add_column :budget_investments, :kind, :integer, default: 0
  end
end
