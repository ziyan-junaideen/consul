class RemoveUriFieldsFromBudget < ActiveRecord::Migration
  def change
    remove_column :budgets, :commitee_list_uri
    remove_column :budgets, :volunteer_form_uri
    remove_column :budgets, :delegate_form_uri
  end
end
