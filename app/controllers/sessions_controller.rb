class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by 担当者コード:params[:session][:担当者コード]
    if user && (user.authenticate params[:session][:password])
      params[:session][:remember_me] ? remember(user) : forget(user)
      flash[:success] = t "message.wellcome_to"
      log_in user
    else
      flash[:danger] = t "message.invalid_email_password"
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
