class AddGuestIdeasToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :guest_ideas, :boolean, default: false
  end
end
