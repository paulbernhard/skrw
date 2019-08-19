module Skrw
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    include Skrw::Concerns::ApplicationController
    layout "application"

    def after_sign_in_path_for(resource)
      Skrw.after_sign_in_path
    end

    def after_sign_out_path_for(resource_or_scope)
      Skrw.after_sign_out_path
    end
  end
end
