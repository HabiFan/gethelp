class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_author, only: [:new, :create, :show, :index]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new(author_id: @author.id)
  end

  def edit
  end

  def create
    @question = Question.new(question_params.merge(author_id: @author.id))

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @question.author == current_user && @question.destroy
      redirect_to questions_path, notice: 'Your question successfully delete!'
    else
      redirect_to questions_path, notice: 'The question cannot be deleted!'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def set_author
    @author ||= current_user
  end

  def question_params
    params.require(:question).permit(:title, :body, :author_id)
  end
end
