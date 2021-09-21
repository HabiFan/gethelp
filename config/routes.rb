Rails.application.routes.draw do
  devise_for :users
  resources :questions do 
    patch :best_answer, on: :member   
    resources :answers, shallow: true, except: [:index, :show]     
  end

  root to: 'questions#index'
end
