require "rails_helper"

describe "Documents" do

  before do
    admin = create(:administrator)
    login_as(admin.user)
  end

  scenario "Navigation", :js do
    visit admin_root_path

    within("#side_menu") do
      click_link "Site content"
      click_link "Custom documents"
    end

    expect(page).to have_link "Add new document",
                              href: new_admin_site_customization_document_path
  end

  scenario "Index" do
    3.times { create(:document, :admin) }
    1.times { create(:document) }

    visit admin_site_customization_documents_path

    expect(page).to have_content "There are 3 documents"

    document = Document.first
    expect(page).to have_link document.title, href: document.attachment.url
  end

  scenario "Index (empty)" do
    visit admin_site_customization_documents_path

    expect(page).to have_content "There are no documents."
  end

  scenario "Index (pagination)" do
    per_page = Kaminari.config.default_per_page
    (per_page + 5).times { create(:document, :admin) }

    visit admin_site_customization_documents_path

    expect(page).to have_selector("#documents .document", count: per_page)

    within("ul.pagination") do
      expect(page).to have_content("1")
      expect(page).to have_link("2", href: admin_site_customization_documents_url(page: 2))
      expect(page).not_to have_content("3")
      click_link "Next", exact: false
    end

    expect(page).to have_selector("#documents .document", count: 5)
  end

  scenario "Create" do
    visit new_admin_site_customization_document_path

    attach_file("document_attachment", Rails.root + "spec/fixtures/files/logo.pdf")
    click_button "Upload"

    expect(page).to have_content "Document uploaded succesfully"
    expect(page).to have_link "logo.pdf", href: Document.last.attachment.url
  end

  scenario "Errors on create" do
    visit new_admin_site_customization_document_path

    click_button "Upload"

    expect(page).to have_content "Invalid document"
  end

  scenario "Destroy", :js do
    document = create(:document, :admin)

    visit admin_site_customization_documents_path

    within("#document_#{document.id}") do
      accept_confirm { click_link "Delete" }
    end

    expect(page).to have_content "Document deleted succesfully"
    expect(page).not_to have_content document.title
  end

end
