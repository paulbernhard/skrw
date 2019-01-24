module Skrw
  class Upload < ApplicationRecord
    include Skrw::Concerns::Uploadable
    belongs_to :uploadable, polymorphic: true, optional: true
  end
end