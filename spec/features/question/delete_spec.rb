require 'rails_helper'

feature 'The user wants to delete their questions or answers', %q{
  The user wants to delete 
  their questions or answers. 
  But cannot delete other 
  people's questions or answers
} do
  given!(:user) { create(:user) }
  given(:other_user) { create(:user) }
  
  background { sign_in(user) }

  describe 'User can delete' do
  
    given!(:question) {  create(:question, author: user) }
    given!(:answer) { create(:answer, author: user, question: question) }

    scenario 'their question' do
      visit questions_path      
      click_on "Delete #{question.title}"
      
      expect(page).to have_content 'Your question successfully delete!'
    end
    
    scenario 'their answer' do
      visit question_path(question)
      click_on "Delete answer"
      
      expect(page).to have_content 'Your answer successfully delete!'
    end
  end

  describe "User cannot delete" do    
    given!(:question) {  create(:question, author: other_user) }
    given!(:answers) { create(:answer, question: question, author: other_user) }
      
    scenario "other people's question" do
      visit questions_path      
      click_on "Delete #{question.title}"
      
      expect(page).to have_content 'The question cannot be deleted!'
    end

    scenario "other people's answer" do
      visit question_path(question)
      click_on "Delete answer"
      
      expect(page).to have_content 'The answer cannot be deleted!'
    end
  end
end
