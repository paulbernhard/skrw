Skrw::Engine.routes.draw do

  # devise routes
  devise_for :users, class_name: 'Skrw::User', module: :devise, skip: [:sessions]

  # custom devise routes
  devise_scope :user do
    get     'login', to: 'sessions#new', as: :new_user_session
    post    'login', to: 'sessions#create', as: :user_session
    delete  'logout', to: 'sessions#destroy', as: :destroy_user_session
  end

  # TODO add routes/controller for registrations

  root to: 'users#index'
end
