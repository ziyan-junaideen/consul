class AddLimitVotingOnBudgetToGroups < ActiveRecord::Migration
  def change
    add_column :budget_groups, :limit_voting_on_budget, :boolean, default: true
  end
end
