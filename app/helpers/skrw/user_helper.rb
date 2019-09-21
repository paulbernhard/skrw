module Skrw
  module UserHelper

    # if signed in or request to sessions controller
    def skrw_session?
      if user_signed_in? || params[:controller] == "skrw/sessions"
        return true
      else
        return false
      end
    end

    # signed in as admin?
    def admin_signed_in?
      if user_signed_in? && current_user.admin
        return true
      else
        return false
      end
    end

    # render user bar
    # with controls if logged in as :user (default) or :admin
    def skrw_user_bar(auth = :user, &block)
      if block_given? && send("#{auth}_signed_in?")
        content_for(:skrw_controls) { yield }
      end

      capture do
        concat render(partial: "skrw/sessions/session") if send("#{auth}_signed_in?")
        concat render(partial: "skrw/sessions/flash") if skrw_session?
      end

      # render(partial: "skrw/sessions/session") if send("#{auth}_signed_in?")

      # if send("#{auth}_signed_in?")
      #   render 'skrw/sessions/session'
      # end
    end
  end
end
