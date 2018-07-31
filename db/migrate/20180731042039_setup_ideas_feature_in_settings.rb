class SetupIdeasFeatureInSettings < ActiveRecord::Migration
  KEY = 'feature.ideas'.freeze

  def up
    Setting[KEY] = false
  end

  def down
    SEtting.where(key: KEY).delete_all
  end
end
