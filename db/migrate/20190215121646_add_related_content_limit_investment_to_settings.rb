class AddRelatedContentLimitInvestmentToSettings < ActiveRecord::Migration
  def up
    Setting['pb-toggle.related_content.limit_investments'] = false
  end

  def down
    Setting.where(key: 'pb-toggle.related_content.limit_investments').delete_all
  end
end
