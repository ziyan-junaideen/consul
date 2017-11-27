class CreateRelatives < ActiveRecord::Migration
  def change
    create_table :relatives do |t|
      t.integer :first_relative_id
      t.integer :second_relative_id
      t.string :first_relative_type
      t.string :second_relative_type

      t.integer :duplicated_id

      t.integer :times_reported, default: 0
      t.boolean :hidden, default: false
    end
  end
end
