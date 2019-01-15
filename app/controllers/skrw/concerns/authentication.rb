module Skrw::Concerns::Authentication
  # extend ActiveSupport::Concern

  def authenticate_admin!
    if !user_signed_in? || !current_user.admin
      sign_out(current_user) if user_signed_in?
      flash[:notice] = t('devise.failure.unauthenticated_admin')
      redirect_to skrw.new_user_session_path
    end
  end
end