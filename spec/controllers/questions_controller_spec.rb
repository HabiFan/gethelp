require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    
    before { get :index }


    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end


    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end


    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question).merge(author_id: user) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question).merge(author_id: user) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end


      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'edits his answer question' do
      let(:question) { create(:question, author: user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirects to updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change question' do
          question.reload

          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

        it 're-renders edit view' do
          expect(response).to render_template :update
        end
      end      
    end

    context "tries to edit other user's question" do
      let!(:other_user) { create(:user) }
      let!(:question) { create(:question, author: other_user) }

      before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js }

      it "does not change other user's question" do
        question.reload

        expect(question.title).not_to eq 'new title'
        expect(question.body).not_to eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    
    context 'the author is the user' do 
      let!(:question) { create(:question, author: user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question }, format: :js  }.to change(Question, :count).by(-1)
      end
    end

    context 'non-user author' do
      let!(:other_user) { create(:user) }
      let!(:question) { create(:question, author: other_user) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question }, format: :js  }.not_to change(Question, :count)
      end
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }, format: :js 
      expect(response).to render_template :destroy
    end
  end

  describe 'BEST_ANSWER #best_answer' do
    before { login(user) }
    
    context 'the author is the question' do 
      let!(:question) { create(:question, author: user) }
      let!(:answer) { create(:answer, question: question) }

      before { patch :best_answer, params: { id: question, answer_id: answer.id }, format: :js }

      it 'can choose best answer the question' do
        expect(question.reload.best_answer_id).to eq answer.id
        expect(response).to render_template :best_answer
      end
    end

    context 'non-user author the question' do
      let!(:other_user) { create(:user) }
      let!(:question) { create(:question, author: other_user) }
      let!(:answer) { create(:answer, question: question) }
      
      before { patch :best_answer, params: { id: question, answer_id: answer.id }, format: :js }
      
      it 'does not choose best answer the question' do
        expect(question.reload.best_answer_id).to_not eq answer.id
      end

      it 're-renders best_answer' do
        expect(response).to render_template :best_answer
      end
    end



  end
end

