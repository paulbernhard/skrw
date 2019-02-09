require 'sidekiq/web' if Skrw.process_uploads_in_background_job

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
  resources :uploads, only: [:index, :create, :update, :destroy], defaults: { format: :json }

  # sidekiq web UI (if background processing is enabled)
  if Skrw.process_uploads_in_background_job
    authenticate :user do
      mount Sidekiq::Web => 'sidekiq'
    end
  end

  root to: 'users#index'
end
