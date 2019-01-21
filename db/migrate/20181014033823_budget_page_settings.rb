class BudgetPageSettings < ActiveRecord::Migration
  def up
    Setting['feature.budget_page.all_phases'] = true
    Setting['feature.budget_page.footer'] = true
    Setting['feature.budget_page.finished_budgets'] = true
  end

  def down
    Setting['feature.budget_page.all_phases'] = nil
    Setting['feature.budget_page.footer'] = nil
    Setting['feature.budget_page.finished_budgets'] = nil
  end
end
