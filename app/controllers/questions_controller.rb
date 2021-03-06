class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
   before_action :load_question, only: [:show, :edit, :update, :destroy, :best_answer]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @best_answer = @question.best_answer
		@answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def new
    @question = Question.new(author_id: current_user.id)
  end

  def edit
  end

  def create
    @question = Question.new(question_params.merge(author_id: current_user.id))

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question) 
      @question.update(question_params)      
    end
  end

  def best_answer
    @answer = Answer.find(params[:answer_id])
    if current_user.author_of?(@question)
       @question.mark_as_best(@answer)
       @best_answer = @question.best_answer
		   @answers = @question.answers.where.not(id: @question.best_answer_id)
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
