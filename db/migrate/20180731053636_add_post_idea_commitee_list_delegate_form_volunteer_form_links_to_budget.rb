class AddPostIdeaCommiteeListDelegateFormVolunteerFormLinksToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :post_idea_uri, :string
    add_column :budgets, :commitee_list_uri, :string
    add_column :budgets, :volunteer_form_uri, :string
    add_column :budgets, :delegate_form_uri, :string
  end
end
