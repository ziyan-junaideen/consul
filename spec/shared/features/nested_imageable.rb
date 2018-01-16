shared_examples "nested imageable" do |imageable_factory_name, path, imageable_path_arguments, fill_resource_method_name, submit_button, imageable_success_notice, has_many_images = false|
  include ActionView::Helpers
  include ImagesHelper
  include ImageablesHelper

  let!(:user)                { create(:user, :level_two) }
  let!(:administrator)       { create(:administrator, user: user) }
  let!(:arguments)           { {} }
  let!(:imageable)           { create(imageable_factory_name) }

  before do
    Setting['feature.allow_images'] = true

    imageable_path_arguments&.each do |argument_name, path_to_value|
      arguments.merge!("#{argument_name}": imageable.send(path_to_value))
    end

    imageable.update(author: user) if imageable.respond_to?(:author)
  end

  after do
    Setting['feature.allow_images'] = nil
  end

  describe "at #{path}" do

    scenario "Create image", :js do
      login_as user
      visit send(path, arguments)

      click_link "Add image"
      expect(page).to have_content "Choose image"

      attach_file(image_input[:id], "spec/fixtures/files/clippy.jpg", make_visible: true)

      expect(page).to have_link("Remove image", href: /#{direct_upload_destroy_path}/) #Trying to avoid flakiness
      expect(page).to have_selector ".file-name", text: "clippy.jpg" #(Should update nested image file name after choosing any file)
      expect(page).to have_selector ".loading-bar.complete" #(Should update loading bar style after valid file upload)
      expect_image_has_title("clippy.jpg") #(Should update nested image file title with file name after choosing a file when no title defined)
      expect_image_has_cached_attachment(".jpg") #(Should update image cached_attachment field after valid file upload)

      send(fill_resource_method_name) if fill_resource_method_name
      click_on submit_button
      expect(page).to have_content imageable_success_notice

      imageable_redirected_to_resource_show_or_navigate_to #Visit Show

      expect(page).to have_selector "figure img"
      expect(page).to have_selector "figure figcaption"
    end

    scenario "View image" do
      #Index
      #Show
    end

    scenario "Update", :js do
      skip unless path.include? "edit"

      login_as user
      create(:image, imageable: imageable)
      visit send(path, arguments)

      expect(page).to have_content "Edit proposal"
      expect(page).to have_css ".image", count: 1 #"Should show persisted image"
      expect(page).to have_css "a#new_image_link", visible: false #"Should not show add image button when image already exists"

      ###"Should remove nested field after remove image"
      click_on "Remove image"
      expect(page).not_to have_css ".image"
      ###
      expect(page).to have_css "a#new_image_link", visible: true #"Should show add image button after remove image"
    end

    scenario "Destroy image" do
      #destroy
    end

    scenario "Errors on create", :js do
      login_as user
      visit send(path, arguments)

      click_link "Add image"
      expect(page).to have_content "Choose image"

      image_input = find(".image").find("input[type=file]", visible: false)
      attach_file(image_input[:id], "spec/fixtures/files/logo_header.png", make_visible: true)

      expect(page).to have_selector ".loading-bar.errors"
      expect_image_has_cached_attachment("")

      within "#nested-image .image" do
        expect(page).to have_content("type image/png does not match any of accepted content types jpeg, jpg", count: 1) #Note: It should probably be png not allowed Should show nested image errors after unvalid form submit
      end
    end

    scenario "Errors on update", :js do
    end

    scenario "Set a custom file name", :js do #"Should not update nested image file title with file name after choosing a file when title already defined"
      login_as user
      visit send(path, arguments)

      click_link "Add image"
      expect(page).to have_content "Choose image"

      input_title = find(".image input[name$='[title]']")

      fill_in input_title[:id], with: "File 123"

      image_input = find(".image").find("input[type=file]", visible: false)
      attach_file(image_input[:id], "spec/fixtures/files/clippy.jpg", make_visible: true)

      if has_many_images
        expect(find("input[id$='_title']").value).to eq "File 123"
      else
        expect(find("##{imageable_factory_name}_image_attributes_title").value).to eq "File 123"
      end
    end

    scenario "Should remove nested image after valid file upload and click on remove button", :js do
      login_as user
      visit send(path, arguments)

      imageable_attach_new_file(imageable_factory_name, "spec/fixtures/files/clippy.jpg")
      within "#nested-image .image" do
        click_link "Remove image"
      end

      expect(page).not_to have_selector("#nested-image .image")
    end

  end

end

def imageable_redirected_to_resource_show_or_navigate_to
  find("a", text: "Not now, go to my proposal")
  click_on "Not now, go to my proposal"
rescue
  return
end

def imageable_attach_new_file(_imageable_factory_name, path, success = true)
  click_link "Add image"
  #expect(page).to have_button "Choose image"

  within "#nested-image" do
    image = find(".image")
    image_input = image.find("input[type=file]", visible: false)
    attach_file(image_input[:id], path, make_visible: true)
    within image do
      if success
        expect(page).to have_css(".loading-bar.complete")
      else
        expect(page).to have_css(".loading-bar.errors")
      end
    end
  end
end

def imageable_fill_new_valid_proposal
  fill_in :proposal_title, with: "Proposal title #{rand(99999)}"
  fill_in :proposal_summary, with: "Proposal summary"
  fill_in :proposal_question, with: "Proposal question?"
  check :proposal_terms_of_service
end

def imageable_fill_new_valid_budget_investment
  page.select imageable.heading.name_scoped_by_group, from: :budget_investment_heading_id
  fill_in :budget_investment_title, with: "Budget investment title"
  fill_in_ckeditor "budget_investment_description", with: "Budget investment description"
  check :budget_investment_terms_of_service
end

def expect_image_has_title(title)
  image = find(".image")

  within image do
    expect(find("input[name$='[title]']").value).to eq title
  end
end

def expect_image_has_cached_attachment(extension)
  within "#nested-image" do
    image = find(".image")

    within image do
      expect(find("input[name$='[cached_attachment]']", visible: false).value).to end_with(extension)
    end
  end
end

def image_input
  find(".image").find("input[type=file]", visible: false)
end