class ApplicationController < ActionController::Base
  respond_to :html
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    render json: exception.message
  end

  check_authorization unless: :devise_controller?
end
