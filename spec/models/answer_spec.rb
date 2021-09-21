require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:author) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end
  
  describe 'best_of?' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    

    it 'return true' do 
      question.mark_as_best(answer)
      expect(answer).to be_best_of
    end

    it 'return false' do 
      expect(answer).not_to be_best_of
    end
  end
end
