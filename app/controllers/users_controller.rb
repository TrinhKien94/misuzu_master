class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  respond_to :js

  include UsersHelper

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  # def edit
  # end

  # POST /users
  # POST /users.json
  def create
    case params[:commit]
      when '登録する'
        @user = User.new(user_params)
        if @user.save
          flash[:notice] = t "app.flash.new_success"
          email = user_params[:email]
          new_pass = user_params[:パスワード]
          Mail.deliver do
            to "#{email}"
            from 'hminhduc@gmail.com'
            subject '【勤務システム】ログインパスワード変更'
            body "パスワードを変更成功できました。この際から、ID:【#{session[:user]}】 PASS:【#{new_pass}】でログインしてくさだい！"
          end

        end
        respond_with @user, location: login_users_url

      when 'ログイン'
        if ENV['admin_user'] == params[:user][:担当者コード].downcase && ENV['admin_password'] == params[:user][:パスワード]
          session[:user] = ENV['admin_user']
          session[:current_user_id] = ENV['admin_user']
          redirect_to users_url
          return
        end

        @user = User.where('担当者コード = ? AND パスワード = ?',params[:user][:担当者コード].downcase, params[:user][:パスワード]).first

        if @user.nil?
          flash.now[:alert] = t "app.flash.login_field"
          render "login"
        else
          # todo store session
          session[:user] = @user.id
          session[:current_user_id] = @user.id
          session[:selected_shain] = @user.shainmaster.id
          # 現在保留
          # check_shozai()
          check_kintai_at_day(Date.today)
          respond_with @user, location: time_line_view_events_url
        end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update user_params_for_update
      flash[:notice] = t "app.flash.update_success"
      email = user_params_for_update[:email]
      new_pass = user_params_for_update[:パスワード]
      Mail.deliver do
        to "#{email}"
        from 'hminhduc@gmail.com'
        subject '【勤務システム】ログインパスワード変更'
        body "パスワードを変更成功できました。この際から、【#{new_pass}】でログインしてくさだい！"
      end

      redirect_to root_url
    else
      respond_with @user
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_with @user
  end

  def change_pass
    if request.post?
      @user = User.find_by(担当者コード: params[:user][:user_code].downcase, パスワード: params[:user][:old_password])

      if !@user.nil?
        new_pass = params[:user][:new_password]
        email = params[:user][:email]
        avatar = params[:user][:avatar]

        if new_pass == params[:user][:renew_password]
          flash[:notice] = t 'app.flash.update_success' if @user.update(パスワード: new_pass, email: email, avatar: avatar)
          Mail.deliver do
            to "#{email}"
            from 'hminhduc@gmail.com'
            subject '【勤務システム】ログインパスワード変更'
            body "パスワードを変更成功できました。この際から、【#{new_pass}】でログインしてくさだい！"
          end
          redirect_to root_url
        else
          redirect_to :back, notice: '新パスワードともう一度パスワードが異なります。'
        end
      else
        redirect_to :back, notice: 'ユーザーIDまたはパスワードが間違っています。'
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:担当者コード, :担当者名称, :パスワード, :再パスワード, :avatar, :admin, :有給残数, :email)
  end

  def user_params_for_update
    params.require(:user).permit(:担当者名称, :パスワード, :再パスワード, :avatar, :admin, :有給残数, :email)
  end
end
