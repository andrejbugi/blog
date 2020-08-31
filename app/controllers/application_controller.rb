class ApplicationController < ActionController::Base
  include SessionsHelper
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :require_login

  private

  def require_login
    unless logged_in?
      flash[:danger] = 'Please sign in to continue.'
      redirect_to login_path
    end
  end

  # def not_found
  #   redirect_to '/404.html'
  # end
end
