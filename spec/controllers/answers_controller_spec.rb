require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  
  let(:user) { create(:user) }
  let(:question) { create(:question) }  
  let(:answer) { create(:answer, question: question) }
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'non-user author' do
      let!(:other_user) { create(:user) }
      let!(:answer) { create(:answer, author: other_user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end
    end
    
    it 'redirects to answer' do
      delete :destroy,  params: { id: answer }, format: :js 
      expect(response).to render_template :destroy 
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:question).merge(author_id: user) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:question).merge(author_id: user), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(question.answers, :count)
      end


      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'edits his answer' do
      let!(:answer) { create(:answer, question: question, author: user) }
      context 'with valid attributes' do
        it 'assigns the requested answers to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js 
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'updated answer redirects to question' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not change answer' do
          answer.reload

          expect(answer.body).to eq answer.body
        end

        it 're-renders edit view' do
          expect(response).to render_template :update
        end
      end
    end
    context "tries to edit other user's answer" do
      let!(:other_user) { create(:user) }
      let!(:answer) { create(:answer, question: question, author: other_user) }

      before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

      it 'does not change answer' do       
        
        answer.reload

        expect(answer.body).not_to eq 'new body'
      end
    end
  end
end

