class UpdateExistingPbSettingKeys < ActiveRecord::Migration
  def up
    Setting['pb-toggle.budget_page.all_phases'] = Setting['feature.budget_page.all_phases'] = true
    Setting['pb-toggle.budget_page.footer'] = Setting['feature.budget_page.footer'] = true
    Setting['pb-toggle.budget_page.finished_budgets'] = Setting['feature.budget_page.finished_budgets'] = true
    Setting['pb-input.map_height'] = Setting['map_height']

    Setting.where(key: 'feature.budget_page.all_phases').destroy_all
    Setting.where(key: 'feature.budget_page.footer').destroy_all
    Setting.where(key: 'feature.budget_page.finished_budgets').destroy_all
    Setting.where(key: 'map_height').destroy_all
  end

  def down
  end
end
