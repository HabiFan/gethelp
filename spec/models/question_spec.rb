require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) } 
    it { should belong_to(:author) }
    it { should belong_to(:best_answer).optional }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'mark_as_best' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'update question with best answer' do 
      expect(question.mark_as_best(answer)).to be_truthy
      expect(question).to have_attributes(best_answer_id: answer.id)
    end   
  end



end
