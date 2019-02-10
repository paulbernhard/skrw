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

    def user_bar
      render 'skrw/sessions/session' if session?
    end

    def user_bar_controls(level = :secondary, **options)
      content_for("skrw_page_controls_#{level}".to_sym, options) { yield }
    end
  end
end