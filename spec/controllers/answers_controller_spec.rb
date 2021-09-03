require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  
  let(:user) { create(:user) }
  let(:question) { create(:question) }  
  let(:answer) { create(:answer) }
  before { login(user) }

  describe 'GET #new' do
    
    before { get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
       expect(assigns(:answer)).to be_a_new(Answer) 
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    
    before { get :edit, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'DELETE #destroy' do    
    context 'the author is the user' do
      let!(:answer) { create(:answer, author: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end
    end

    context 'non-user author' do
      let!(:other_user) { create(:user) }
      let!(:answer) { create(:answer, author: other_user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end
    end
    
    it 'redirects to question' do
      delete :destroy,  params: { id: answer }
      expect(response).to redirect_to answer.question
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:question).merge(author_id: user) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:question).merge(author_id: user) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end


      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested answers to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'updated answer redirects to question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'Text11'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end
end

