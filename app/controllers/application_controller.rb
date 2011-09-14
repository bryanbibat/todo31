class ApplicationController < ActionController::Base
  protect_from_forgery

  http_basic_authenticate_with name: Auth.user, password: Auth.pwd
end
