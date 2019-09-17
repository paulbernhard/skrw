module Skrw
  module UserHelper

    def skrw_session?
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

    def user_bar(&block)
      content_for(:skrw_controls) { yield } if block_given?
      render 'skrw/sessions/session'
    end

    def user_bar_controls(&block)
      content_for(:skrw_controls) { yield }
    end
  end
end
