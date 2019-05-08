module Skrw
  module Singleton
    extend ActiveSupport::Concern

    included do
      validates :singleton_guard, presence: true
      validates :singleton_guard, inclusion: { in: [0] }
      validates :singleton_guard, uniqueness: true
    end

    class_methods do

      def instance
        site = self.first
        if site.nil?
          site = self.new(singleton_guard: 0)
          site.save(validate: false)
          site
        else
          site
        end
      end
    end
  end
end
