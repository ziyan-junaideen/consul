class AddPublishedToBudgetInvestments < ActiveRecord::Migration
  def change
    add_column :budget_investments, :published, :boolean, default: true
  end
end
