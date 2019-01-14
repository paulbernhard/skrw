Rails.application.routes.draw do
  resources :posts
  mount Skrw::Engine => "/skrw"
end
