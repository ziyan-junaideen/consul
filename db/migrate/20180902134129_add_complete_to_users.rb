class AddCompleteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :complete, :boolean, default: true
  end
end
