module Skrw
  class PromoteJob
    include Sidekiq::Worker

    def perform(data)
      Shrine::Attacher.promote(data)
    end
  end
end