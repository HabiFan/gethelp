class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  def best_of?
    self.id == self.question.best_answer_id
  end

end
