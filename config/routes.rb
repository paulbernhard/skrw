Skrw::Engine.routes.draw do

  # devise routes
  devise_for  :users, class_name: 'Skrw::User', module: :devise,
              skip: [:sessions]

  # custom devise routes
  devise_scope :user do
    get     'login', to: 'sessions#new', as: :new_user_session
    post    'login', to: 'sessions#create', as: :user_session
    delete  'logout', to: 'sessions#destroy', as: :destroy_user_session
  end

  resources :users, only: [:index, :edit, :update, :destroy]

  root to: 'users#index'
  # TODO add user index, adding, editing functionalities
end
