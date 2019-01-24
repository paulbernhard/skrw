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

  # mount uploader endpoint for ajax / xhr uploads
  mount Skrw::FileUploader.upload_endpoint(:cache) => 'uploads/xhr'
  resources :uploads, only: [:create, :destroy], defaults: { format: :json }

  root to: 'users#index'
end
