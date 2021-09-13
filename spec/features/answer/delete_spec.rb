require 'rails_helper'

feature 'The user wants to delete answers', %q{
  The user wants to delete answers. 
  But cannot delete other 
  people's answers
} do
  given!(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) {  create(:question, author: user) } 
  given!(:answer) { create(:answer, author: user, question: question) } 

  describe 'Authenticated user' do
    background { sign_in(user) }   

    describe "can delete" do
      scenario 'their answer' do
        visit question_path(question)
        
        expect(page).to have_link "Delete answer" 
        expect(page).to have_content "#{answer.body}"
        
        click_on "Delete answer"
         
        expect(page).to have_content 'Your answer successfully delete!'
        expect(page).not_to have_content "#{answer.body}|"
        expect(page).not_to have_link "Delete answer" 
      end
  end

    describe "cannot delete" do   
      given!(:answer) { create(:answer, question: question, author: other_user) }

      scenario "other people's answer" do
        visit question_path(question)
    
        expect(page).not_to have_link "Delete answer"            
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'trying to delete the answer' do
      visit question_path(question)

      expect(page).not_to have_link "Delete answer"
    end
  end
end
