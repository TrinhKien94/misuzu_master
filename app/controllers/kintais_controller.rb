class KintaisController < ApplicationController
  before_action :set_kintai, only: [:edit, :update, :destroy]

  respond_to :json

  include UsersHelper

  def index
    @date_param = Date.today
    @date_param = params[:search] if params[:search].present?

    # @date_param = params[:search]
    # @date_param = Date.today.to_date unless date_param.present?

    date = @date_param.to_date
    session[:selected_kintai_date] = date
    check_kintai_at_day(date)

    case params[:commit]
      when '入力済'
        @kintai = Kintai.find_by(日付: date, 社員番号: session[:user])
        @kintai.入力済 = '1' if @kintai
        @kintai.save
      when '入力する'
        @kintai = Kintai.find_by(日付: date, 社員番号: session[:user])
        @kintai.入力済 = '0' if @kintai
        @kintai.save
    end

    @kintais = Kintai.selected_month(session[:user], date).order(:日付)

    finish_flag = Kintai.find_by(社員番号: session[:user], 日付: date.beginning_of_month).try :入力済 || '0'

    if finish_flag == '1'
      render :show
    else
      render :index
    end
  end

  def search
    @kintais = Kintai.selected_month(session[:user], session[:selected_kintai_date])
  end

  def show
    respond_with(@kintai)
  end

  def new
    @kintai = Kintai.new
    @kintai.勤務タイプ = Shainmaster.find(session[:user]).勤務タイプ
    respond_with(@kintai)
  end

  def edit
    if @kintai.勤務タイプ.nil?
      @kintai.勤務タイプ = Shainmaster.find(session[:user]).勤務タイプ
      @kintai.実労働時間 = 8
      @kintai.遅刻時間 = 0
      @kintai.普通残業時間 = 0
      @kintai.深夜残業時間 = 0
      @kintai.普通保守時間 = 0
      @kintai.深夜保守時間 = 0
      date = @kintai.日付.to_s
      case @kintai.勤務タイプ
        when '001'
          @kintai.出勤時刻 = date + ' 07:00:00'
          @kintai.退社時刻 = date + ' 16:00:00'
        when '002'
          @kintai.出勤時刻 = date + ' 07:30:00'
          @kintai.退社時刻 = date + ' 16:30:00'
        when '003'
          @kintai.出勤時刻 = date + ' 08:00:00'
          @kintai.退社時刻 = date + ' 17:00:00'
        when '004'
          @kintai.出勤時刻 = date + ' 08:30:00'
          @kintai.退社時刻 = date + ' 17:30:00'
        when '005'
          @kintai.出勤時刻 = date + ' 09:00:00'
          @kintai.退社時刻 = date + ' 18:00:00'
        when '006'
          @kintai.出勤時刻 = date + ' 09:30:00'
          @kintai.退社時刻 = date + ' 18:30:00'
        when '007'
          @kintai.出勤時刻 = date + ' 10:00:00'
          @kintai.退社時刻 = date + ' 19:00:00'
        when '008'
          @kintai.出勤時刻 = date + ' 10:30:00'
          @kintai.退社時刻 = date + ' 19:30:00'
        when '009'
          @kintai.出勤時刻 = date + ' 11:00:00'
          @kintai.退社時刻 = date + ' 20:00:00'
      end
    end
  end

  def create
    @kintai = Kintai.new(kintai_params)
    flash[:notice] = t 'app.flash.new_success' if @kintai.save
    respond_with(@kintai, location: kintais_url)
  end

  def update
    if kintai_params[:状態1].in?(['103']) #振出
      params[:kintai][:代休相手日付] = @kintai.日付
      params[:kintai][:代休取得区分] = '0'
    end
    if kintai_params[:状態1].in?(['105']) #振休
      furishutsu = Kintai.current_month(session[:user]).find_by(代休相手日付: kintai_params[:代休相手日付])
      furishutsu.update(代休取得区分: '1', 備考: @kintai.日付.to_s + 'の振出') if furishutsu
    end

    flash[:notice] = t 'app.flash.update_success' if @kintai.update(kintai_params)
    respond_with(@kintai, location: kintais_url)
  end

  def destroy
    flash[:notice] = t 'app.flash.delete_success' if @kintai.destroy
    respond_with(@kintai, location: kintais_url)
  end

  private
    def set_kintai
      @daikyus = Kintai.current_user(session[:user]).where(代休取得区分: '0').select(:代休相手日付)
      @kintai = Kintai.find(params[:id])

      kubunlist = []
      case @kintai.曜日
        when '0','6'
          kubunlist = ['1','5']
        when '1'..'5'
          if @kintai.try(:holiday) == '1'
            kubunlist = ['1','5']
          else
            kubunlist = ['1','2','6']
          end
      end
      @joutais = Joutaimaster.active(kubunlist)
    end

    def kintai_params
      params.require(:kintai).permit(:日付, :曜日, :勤務タイプ, :出勤時刻, :退社時刻, :保守携帯回数, :状態1, :状態2, :状態3, :備考,
                                     :実労働時間, :遅刻時間, :早退時間, :普通残業時間, :深夜残業時間, :普通保守時間, :深夜保守時間,
                                     :holiday, :代休相手日付, :代休取得区分)
    end
end
