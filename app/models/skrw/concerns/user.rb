module Skrw::Concerns::User
  extend ActiveSupport::Concern

  included do
    devise :database_authenticatable,
           :rememberable, :validatable
  end
end
