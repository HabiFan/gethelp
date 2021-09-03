require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  before { @user = create(:user)  }

  it 'author_of? with return true' do      
    Current.user = @user 
    expect(@user.author_of?).to be(true)
  end

  it 'author_of? with return false' do      
    expect(@user.author_of?).to be(false)
  end

 
end