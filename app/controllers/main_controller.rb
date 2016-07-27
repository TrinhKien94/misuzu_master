class MainController < ApplicationController
  before_action :require_user!

  def index
    @kairanCount = Kairanshosai.where(対象者: session[:user], 確認: false).count
    shain = Shainmaster.find_by id: session[:user]
    shain.update_attributes 回覧件数: @kairanCount
  end
end
