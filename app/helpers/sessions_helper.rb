module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  # Finding by id, then from session user id
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in_notice
    flash[:warning] = 'Already Logged In!'
    redirect_to root_path and return
  end
end
