class ShainmastersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_reference, only: [:new, :edit, :create, :update]
  load_and_authorize_resource
  respond_to :js

  def index
  end

  def show

  end

  def new
  end

  def edit
  end

  def create
    @shainmaster.shozokumaster = Shozokumaster.find_by 所属コード:
      shainmaster_params[:所属コード]
    @shainmaster.yakushokumaster = Yakushokumaster.find_by 役職コード:
      shainmaster_params[:役職コード]
    flash[:notice] = t "app.flash.new_success" if @shainmaster.save
    respond_with @shainmaster
  end

  def update
    @shainmaster.shozokumaster = Shozokumaster.find_by 所属コード:
      shainmaster_params[:所属コード]
    @shainmaster.yakushokumaster = Yakushokumaster.find_by 役職コード:
      shainmaster_params[:役職コード]
    flash[:notice] = t "app.flash.update_success" if
      @shainmaster.update_attributes shainmaster_params_for_update
    respond_with @shainmaster
  end

  def destroy
    # session[:selected_shain] = Shainmaster.take.id if
    #   @shainmaster.id == session[:selected_shain]
    @shainmaster.destroy if current_user != @shainmaster.user
    respond_with @shainmaster, location: shainmasters_url
  end

  private
  def shainmaster_params
    params.require(:shainmaster).permit :社員番号, :連携用社員番号, :氏名,
      :所属コード, :直間区分, :役職コード, :内線電話番号, :有給残数
  end

  def shainmaster_params_for_update
    params.require(:shainmaster).permit :連携用社員番号, :氏名, :所属コード,
      :直間区分, :役職コード, :内線電話番号, :有給残数
  end

  def set_reference
    @shozokus = Shozokumaster.all
    @yakushokus = Yakushokumaster.all
  end

end
