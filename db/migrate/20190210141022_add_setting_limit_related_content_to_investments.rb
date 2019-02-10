class AddSettingLimitRelatedContentToInvestments < ActiveRecord::Migration
  def up
    Setting['feature.proposal_related_content'] = false
  end

  def down
    Setting.where(key: 'feature.proposal_related_content').delete_all
  end
end
