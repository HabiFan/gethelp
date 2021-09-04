require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  before do  
    @user = create(:user)
    @question = create(:question, author: @user) 
  end
  it 'author_of?' do      
    expect(@user.author_of?(@question.author)).to be(true)
  end
end