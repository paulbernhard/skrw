module Skrw
  class Engine < ::Rails::Engine
    isolate_namespace Skrw

    # include methods and helpers in host app
    initializer('include_methods_and_helpers') do

      ActiveSupport.on_load(:action_controller) do

        # include ApplicationController methods
        include Skrw::Concerns::ApplicationController

        # include view helpers
        helper Skrw::ApplicationHelper
        helper Skrw::UserHelper
        helper Skrw::FormHelper
      end
    end
  end
end
