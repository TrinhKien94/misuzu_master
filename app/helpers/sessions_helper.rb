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

  def check_shozai
    Temp.find_or_create_by(id: 1)
    temp = Temp.find_by(date: Date.today.to_s(:db), checked: true)
    if temp.nil?
      Temp.find(1).update(date: Date.today.to_s(:db), checked: true)
      Shainmaster.update_all 所在コード: 0
    end
  #   Check event that absance that day
    events = Event.where("Date(開始) = ? AND 状態コード = ?", Date.today.to_s(:db),'30')
    events.each do |event|
      event.shainmaster.update 所在コード: 600
    end
  end

  class MonthRange
    include Enumerable

    def initialize(range)
      @start_date = range.first
      @end_date = range.last
      # @start_date = Date.parse(@start_date)
      # @end_date = Date.parse(@end_date)
    end

    def each
      current_day = @start_date
      while current_day <= @end_date do
        yield current_day
        current_day += 1
      end
    end
  end

  def create_kintai(day)
    if JptHolidayMst.exists?(event_date: day)
      note = '会社休日'
      holiday = '1'
    end
    if day.holiday?(:jp)
      holiday = '1'
      note = day.holidays(:jp)[0][:name]
    end

    Kintai.create!(日付: day, 曜日: day.wday, 社員番号: session[:user], holiday: holiday, 備考: note)
  end
end
