require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:other_user) { create(:user) }
    
    it 'return true' do 
      expect(user.author_of?(question)).to be(true)
    end

    it 'return false' do 
      expect(other_user.author_of?(question)).to be(false)
    end
  end
  
 
end