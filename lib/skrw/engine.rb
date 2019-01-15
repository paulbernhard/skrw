module Skrw
  class Engine < ::Rails::Engine
    isolate_namespace Skrw

    # include helpers
    initializer('authentication') do
      ActiveSupport.on_load(:action_controller) do
        include Skrw::Concerns::Authentication
        helper Skrw::UserHelper
      end
    end
  end
end
