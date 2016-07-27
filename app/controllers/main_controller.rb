class MainController < ApplicationController
  def index
     @kairanCount = Kairanshosai.where(対象者: session[:user], 確認: false).count
    shain = Shainmaster.find(session[:user])
    shain.回覧件数 = @kairanCount
    shain.save
  end
end
