require 'rails_helper'

feature 'User can log out', %q{
  The user logged into 
  the application has 
  the option to log out
} do
  
  given(:user) { create(:user) }

  scenario 'Registered user tries to log out' do
    sign_in(user)
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
