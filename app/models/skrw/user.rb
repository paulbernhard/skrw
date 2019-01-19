module Skrw
  class User < ApplicationRecord
    include Skrw::Concerns::User
  end
end
