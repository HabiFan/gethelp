require 'rails_helper'

feature 'User can choose best answer', %q{
  The user can choose the 
  best answer to his question
} do
  
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do     
    background do
      sign_in(user) 

      visit question_path(question)
    end
    
    scenario 'the author of the question can choose the best answer', js: true do
     
      within '.answers' do
        expect(page).to have_link 'Best!'

        click_on 'Best!'

        within '.usual-answers' do
          expect(page).not_to have_content answer.body  
        end

        within '.best-answer' do
          expect(page).to have_content answer.body  
          expect(page).not_to have_link 'Best!'
        end
      end  
    end    

    context "not author question" do
      given!(:other_user) { create(:user) }
      given!(:question) { create(:question, author: other_user) }
      given!(:answer) { create(:answer, question: question) }

      scenario 'cannot choose the best answer', js: true do

        expect(page).not_to have_link 'Best!'

      end
    end    
  end

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Best!'
  end
end
