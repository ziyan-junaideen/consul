class RemoveOfficerAssigmentComposedIndex < ActiveRecord::Migration[4.2]
  def change
    remove_index "poll_officer_assignments", name: "index_poll_officer_assignments_on_officer_id_and_date"
  end
end
