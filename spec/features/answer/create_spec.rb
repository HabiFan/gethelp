require 'rails_helper'

feature 'User can write an answer to a question', %q{
  The user, being on the question page, 
  can write an answer to the question
} do
  
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) } 

  describe 'Authenticated user' do 
    background do
      sign_in(user)
      
      visit question_path(question)
    end
    
    scenario 'Write an answer to the question', js: true do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      fill_in 'Body', with: 'text1 text1 text1'

      click_on 'Create Answer'
      
      expect(page).to have_content 'text1 text1 text1'

    end
    
    scenario 'answer to the question with errors', js: true do
      
      click_on 'Create Answer'
  
      expect(page).to have_content "Body can't be blank"
      
    end
  end

  scenario 'Unauthenticated user is trying to answer a question' do
    visit question_path(question)

    expect(page).to_not have_content 'Create Answer'
  end
end
