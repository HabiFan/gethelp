class User < ApplicationRecord
  
  has_many :author, class_name: 'Answer', foreign_key: 'author_id', dependent: :destroy
  has_many :author, class_name: 'Question', foreign_key: 'author_id', dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(resource)
    resource.author.present? && self.id == resource.author.id
  end

end
