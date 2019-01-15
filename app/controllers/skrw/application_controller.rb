module Skrw
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include Skrw::Concerns::Authentication

    def after_sign_in_path_for(resource)
      Skrw.after_sign_in_path
    end

    def after_sign_out_path_for(resource_or_scope)
      Skrw.after_sign_out_path
    end
  end
end
