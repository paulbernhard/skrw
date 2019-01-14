module Skrw
  module UserHelper

    def session?
      if user_signed_in? || params[:controller] == "skrw/sessions"
        return true
      else
        return false
      end
    end

    def admin_signed_in?
      if user_signed_in? && current_user.admin
        return true
      else
        return false
      end
    end
  end
end