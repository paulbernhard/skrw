require_dependency "skrw/application_controller"

module Skrw
  class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:index, :edit, :update]
    before_action :authenticate_admin!, only: :destroy

    def index
      @users = User.all
    end

    def edit
      @user = User.find(params[:id])
      if @user != current_user
        flash[:notice] = t('devise.failure.wrong_user')
        redirect_to new_user_session_path
      end
    end

    def update
      @user = User.find(params[:id])
      if @user == current_user && @user.update_attributes(user_params)
        flash[:notice] = t('devise.registrations.updated')
        redirect_to users_path
      else
        flash[:notice] = t('devise.failure.update_failed')
        redirect_to new_user_session_path
      end
    end

    def destroy
      @user = User.find(params[:id])
      if @user != current_user
        @user.destroy
        flash[:notice] = t('devise.registrations.destroyed_other')
        redirect_to users_path
      else
        flash[:notice] = t('devise.failure.wrong_user')
        redirect_to new_user_session_path
      end
    end

    private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
  end
end
