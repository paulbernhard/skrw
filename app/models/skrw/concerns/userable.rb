module Skrw::Concerns::Userable
  extend ActiveSupport::Concern

  included do
    devise :database_authenticatable, 
           :rememberable, :validatable
           
    # TODO implement recovery functionality for user.rb
  end
end