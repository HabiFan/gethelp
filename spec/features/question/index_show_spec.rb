require 'rails_helper'

feature 'The user can view a list of questions or a specific question', %q{
  User, before asking your question,
  you can view a list of questions or a specific question
  which have already been set by other users
} do

  given!(:questions) {  create_list(:question, 5) }
  given!(:question) {  create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }
  

  describe 'user can view ' do
      
    scenario 'list a questions' do
      visit questions_path

      questions.each do |question|
        expect(page).to have_content(question.title)
      end
    end

    scenario 'selected questions and answers to it' do
      visit question_path(question)
 
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
      
      answers.each do |answer|
        expect(page).to have_content(answer.body)
      end
    end
  end
end
