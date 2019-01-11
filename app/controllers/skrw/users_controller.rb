require_dependency "skrw/application_controller"

module Skrw
  class UsersController < ApplicationController

    def index
      authenticate_user!
    end
  end
end
