Skrw::Engine.routes.draw do
  devise_for :users, class_name: 'Skrw::User', module: :devise
end
