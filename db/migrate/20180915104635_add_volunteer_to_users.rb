class AddVolunteerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :volunteer, :boolean, default: false
  end
end
