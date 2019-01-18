module Skrw
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, 
           :rememberable, :validatable
           
    # TODO implement recovery functionality for user.rb
  end
end
