class DengonyoukensController < ApplicationController
  before_action :set_dengonyouken, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @dengonyoukens = Dengonyouken.all
    respond_with(@dengonyoukens)
  end

  def show
    respond_with(@dengonyouken)
  end

  def new
    @dengonyouken = Dengonyouken.new
    respond_with(@dengonyouken)
  end

  def edit
  end

  def create
    @dengonyouken = Dengonyouken.new(dengonyouken_params)
    @dengonyouken.save
    respond_with(@dengonyouken, location: dengonyoukens_url)
  end

  def update
    @dengonyouken.update(dengonyouken_params)
    respond_with(@dengonyouken, location: dengonyoukens_url)
  end

  def destroy
    @dengonyouken.destroy
    respond_with(@dengonyouken)
  end

  private
    def set_dengonyouken
      @dengonyouken = Dengonyouken.find(params[:id])
    end

    def dengonyouken_params
      params.require(:dengonyouken).permit(:種類名, :備考)
    end
end
