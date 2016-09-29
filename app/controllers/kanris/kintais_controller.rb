class Kanris::KintaisController < ApplicationController
  before_action :require_kanriG_user!
  def index
    @shainmasters = Shainmaster.get_kubun
    if params[:date].present?
      @date = params[:date].to_date
    else
      @date = Date.today.to_date
    end
    if params[:user_name].present?
      @user_name = params[:user_name]
      @shainmasters = Shainmaster.all.where(社員番号: @user_name)
    end
  end

  def show
    @shainmaster = Shainmaster.find_by id: params[:id]
    @kintais = @shainmaster.kintais
    @date = Date.today
    @date = params[:date].to_date if params[:date].present?
    check_kintai_at_day_by_user(@shainmaster.id, @date)
    @kintais = @kintais.where(日付: @date.beginning_of_month..@date.end_of_month).
      order(:日付) if params[:date].present?
  end

  def export_excel
    @shainmasters = Shainmaster.get_kubun.sort_by{|shain| shain.id.to_i}
    if params[:date].present?
      @date = params[:date].to_date
    else
      @date = Date.today.to_date
    end
    respond_to do |format|
      format.html
      format.xlsx {render xlsx: 'export_excel', filename: "管理G_勤怠_#{@date}.xlsx"}
    end
  end
end
