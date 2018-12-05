class CreateBudgetDelegates < ActiveRecord::Migration
  def change
    create_table :budget_delegates do |t|
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
