require 'rails_helper'

feature 'Admin volunteers' do
  background do
    @admin = create(:administrator)
    @user  = create(:user)
    @volunteer = create(:volunteer)
    login_as(@admin.user)
    visit admin_volunteers_path
  end

  scenario 'Index' do
    expect(page).to have_content @volunteer.name
    expect(page).to have_content @volunteer.email
    expect(page).not_to have_content @user.name
  end

  scenario 'Create Manager', :js do
    fill_in 'name_or_email', with: @user.email
    click_button 'Search'

    expect(page).to have_content @user.name
    click_link 'Add'
    within("#managers") do
      expect(page).to have_content @user.name
    end
  end

  scenario 'Delete Manager' do
    click_link 'Delete'

    within("#managers") do
      expect(page).not_to have_content @volunteer.name
    end
  end

  context 'Search' do

    background do
      user  = create(:user, username: 'Taylor Swift', email: 'taylor@swift.com')
      user2 = create(:user, username: 'Stephanie Corneliussen', email: 'steph@mrrobot.com')
      @volunteer1 = create(:manager, user: user)
      @volunteer2 = create(:manager, user: user2)
      visit admin_managers_path
    end

    scenario 'returns no results if search term is empty' do
      expect(page).to have_content(@volunteer1.name)
      expect(page).to have_content(@volunteer2.name)

      fill_in 'name_or_email', with: ' '
      click_button 'Search'

      expect(page).to have_content('Managers: User search')
      expect(page).to have_content('No results found')
      expect(page).not_to have_content(@volunteer1.name)
      expect(page).not_to have_content(@volunteer2.name)
    end

    scenario 'search by name' do
      expect(page).to have_content(@volunteer1.name)
      expect(page).to have_content(@volunteer2.name)

      fill_in 'name_or_email', with: 'Taylor'
      click_button 'Search'

      expect(page).to have_content('Managers: User search')
      expect(page).to have_content(@volunteer1.name)
      expect(page).not_to have_content(@volunteer2.name)
    end

    scenario 'search by email' do
      expect(page).to have_content(@volunteer1.email)
      expect(page).to have_content(@volunteer2.email)

      fill_in 'name_or_email', with: @volunteer2.email
      click_button 'Search'

      expect(page).to have_content('Managers: User search')
      expect(page).to have_content(@volunteer2.email)
      expect(page).not_to have_content(@volunteer1.email)
    end
  end

end
