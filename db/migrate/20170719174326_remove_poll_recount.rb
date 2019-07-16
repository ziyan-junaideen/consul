class RemovePollRecount < ActiveRecord::Migration[4.2]
  def change
    remove_index :poll_recounts, column: [:booth_assignment_id]
    remove_index :poll_recounts, column: [:officer_assignment_id]

    drop_table :poll_recounts
  end
end
