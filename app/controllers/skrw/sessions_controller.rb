# require_dependency 'skrw/application_controller'
# require_dependency 'devise/sessions_controller'

module Skrw
  class SessionsController < Devise::SessionsController
    protect_from_forgery prepend: true
  end
end
