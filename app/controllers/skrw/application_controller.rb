module Skrw
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    def authenticate_admin!
      if !user_signed_in? || !current_user.admin
        redirect_to new_user_session_path
      end
    end
  end
end
