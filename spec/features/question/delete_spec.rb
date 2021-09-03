require 'rails_helper'

feature 'The user wants to delete their questions or answers', %q{
  The user wants to delete 
  their questions or answers. 
  But cannot delete other 
  people's questions or answers
} do
  given!(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) {  create(:question, author: user) }

  describe 'Authenticated user' do
    background { sign_in(user) }   

    describe "can delete" do
      scenario 'their ouestion' do
        visit questions_path
        
        expect(page).to have_link "Delete #{question.title}" 
        expect(page).to have_link "#{question.title}"
        
        click_on "Delete #{question.title}" 
         
        expect(page).to have_content 'Your question successfully delete!'
        expect(page).not_to have_link "#{question.title}"
        expect(page).not_to have_link "Delete #{question.title}" 
      end
  end

    describe "cannot delete" do   
      given!(:question) {  create(:question, author: other_user) }

      scenario "other people's question" do
        visit questions_path
    
        expect(page).not_to have_link "Delete #{question.title}"            
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'trying to delete the question' do
      visit questions_path

      expect(page).not_to have_link "Delete #{question.title}"
    end
  end  
end
