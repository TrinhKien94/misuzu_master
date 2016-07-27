module SessionsHelper
  def log_in user
    session[:user] = user.id
    session[:current_user_id] = user.id
    session[:selected_shain] = user.shainmaster.id
    # 現在保留
    # check_shozai()
    check_kintai_at_day(Date.today)
    respond_with user, location: time_line_view_events_url
  end

  def current_user
    if user_id = session[:current_user_id]
      @current_user ||= User.find_by id: user_id
    elsif user_id = cookies.signed[:current_user_id]
      user = User.find_by id: user_id
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def remember user
    user.remember
    cookies.permanent.signed[:current_user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def log_out
    forget current_user
    session.delete :current_user_id
    @current_user = nil
  end

  def forget user
    user.forget
    cookies.delete :current_user_id
    cookies.delete :remember_token
  end

  def current_user? user
    user == current_user
  end

  def redirect_back_or default
    redirect_to session[:forwarding_url] || default
    session.delete :forwarding_url
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  def check_kintai_at_day(at_day)
    at_day = Date.today if at_day.nil?
    kintai = Kintai.find_by 日付: at_day, 社員番号: session[:user]
    return if kintai
    start_date = at_day.beginning_of_month
    end_date = at_day.end_of_month
    MonthRange.new(start_date..end_date).each {|day| create_kintai(day)}
  end
end
