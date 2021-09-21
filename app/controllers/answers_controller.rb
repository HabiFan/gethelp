class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:new, :create]
  before_action :set_answer, only: [:edit, :update, :destroy]

  def new
    @answer = @question.answers.new
  end
  
  def edit
  end

  def create
    @answer = @question.answers.create(answer_params.merge(author_id: current_user.id))
  end
  
  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy     
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
