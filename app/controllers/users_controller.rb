class UsersController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: [:new, :create]

  # GET /users
  # GET /users.json
  def index
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    if @user.save
      log_in @user
      flash[:notice] = t "app.flash.new_success"
      respond_with @user, location: login_path
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update user_params_for_update
      flash[:notice] = t "app.flash.update_success"
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
      @user = User.find_by(担当者コード: params[:user][:user_code].downcase, password: params[:user][:old_password])

      if !@user.nil?
        new_pass = params[:user][:new_password]
        email = params[:user][:email]
        avatar = params[:user][:avatar]

        if new_pass == params[:user][:renew_password]
          flash[:notice] = t 'app.flash.update_success' if @user.update(password: new_pass, email: email, avatar: avatar)
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
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit :担当者コード, :担当者名称, :password,
      :password_confirmation, :avatar, :admin, :有給残数, :email
  end

  def user_params_for_update
    params.require(:user).permit :担当者名称, :password, :password_confirmation,
      :avatar, :admin, :有給残数, :email
  end
end
