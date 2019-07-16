require "rails_helper"

describe "Admin dashboard actions" do
  let(:admin) { create :administrator }

  before do
    login_as(admin.user)
  end

  it_behaves_like "nested documentable",
                  "administrator",
                  "dashboard_action",
                  "new_admin_dashboard_action_path",
                  { },
                  "documentable_fill_new_valid_dashboard_action",
                  "Save",
                  "Action created successfully"

  context "when visiting index" do
    context "and no actions defined" do
      before do
        visit admin_dashboard_actions_path
      end

      scenario "shows only default actions" do
        expect(page).to have_content("Polls")
        expect(page).to have_content("Email")
        expect(page).to have_content("Poster")

        expect(page).to have_selector("a", text: "Edit", count: 3)
      end
    end

    context "and actions defined" do
      let!(:action) { create :dashboard_action }

      before do
        visit admin_dashboard_actions_path
      end

      scenario "shows the action data" do
        expect(page).to have_content(action.title)
      end
    end
  end

  context "when creating an action" do
    let(:action) { build :dashboard_action }

    before do
      visit admin_dashboard_actions_path
      click_link "Create resource or action"
    end

    scenario "Creates a new action" do
      fill_in "dashboard_action_title", with: action.title
      fill_in "dashboard_action_description", with: action.description

      click_button "Save"

      expect(page).to have_content(action.title)
    end

    scenario "Renders create form in case data is invalid" do
      click_button "Save"
      expect(page).to have_content("errors prevented this Dashboard/Action from being saved.")
    end
  end

  context "when editing an action" do
    let!(:action) { create :dashboard_action }
    let(:title) { Faker::Lorem.sentence }

    before do
      visit admin_dashboard_actions_path
      within ("#dashboard_action_#{action.id}") do
        click_link "Edit"
      end
    end

    scenario "Updates the action" do
      fill_in "dashboard_action_title", with: title
      click_button "Save"

      expect(page).to have_content(title)
    end

    scenario "Renders edit form in case data is invalid" do
      fill_in "dashboard_action_title", with: "x"
      click_button "Save"
      expect(page).to have_content("error prevented this Dashboard/Action from being saved.")
    end
  end

  context "when destroying an action" do
    let!(:action) { create :dashboard_action }

    before do
      visit admin_dashboard_actions_path
    end

    scenario "deletes the action", js: true do
      page.accept_confirm do
        click_link "Delete"
      end

      expect(page).not_to have_content(action.title)
    end

    scenario "can not delete actions that have been executed", js: true do
      _executed_action = create(:dashboard_executed_action, action: action)

      page.accept_confirm do
        click_link "Delete"
      end

      expect(page).to have_content("Cannot delete record because dependent executed actions exist")
    end
  end
end
