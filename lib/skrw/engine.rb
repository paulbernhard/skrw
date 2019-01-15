module Skrw
  class Engine < ::Rails::Engine
    isolate_namespace Skrw

    # include helpers
    initializer('authentication') do
      ActiveSupport.on_load(:action_controller) do
        helper Skrw::UserHelper
        include Skrw::Concerns::Authentication
      end
    end
  end
end
