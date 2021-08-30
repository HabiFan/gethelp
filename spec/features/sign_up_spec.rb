require 'rails_helper'

feature 'User tries to register', %q{
  The user, being unregistered, 
  wants to be able to register
} do
  
  
  scenario 'User wants to register' do
    visit root_path
    click_on 'Registration'
    fill_in 'Email',	with: 'user23@test.com'
    fill_in 'Password',	with: '12345678'
    fill_in 'Password confirmation',	with: '12345678'
    
    click_on 'Sign up'
    
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
