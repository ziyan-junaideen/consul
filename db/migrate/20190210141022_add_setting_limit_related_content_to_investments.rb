class AddSettingLimitRelatedContentToInvestments < ActiveRecord::Migration
  def up
    Setting['feature.limit_related_content_to_investments'] = true
  end

  def down
    Setting.where(key: 'feature.limit_related_content_to_investments').delete_all
  end
end
