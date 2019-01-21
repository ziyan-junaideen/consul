class AddMapHeightToSetting < ActiveRecord::Migration
  def up
    Setting.create(key: 'map_height', value: '350')
  end

  def down
    Setting.where(key: 'map_height').delete_all
  end
end
