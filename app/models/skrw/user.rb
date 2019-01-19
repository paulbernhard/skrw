module Skrw
  class User < ApplicationRecord
    include Skrw::Concerns::Userable
  end
end
