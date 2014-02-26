class JewelleriesController < ApplicationController
  before_action :authenticate

  REQUIRED_PARAMS  = %i( name description gallery image )
  PERMITTED_PARAMS = %i( name description gallery image )

  def new
    @jewellery = Jewellery.new
  end

  def create
    verify_required_params!

    Jewellery.create!(jewellery_params)
    redirect_to admin_path
  rescue ActionController::ParameterMissing, ActiveRecord::RecordInvalid => e
    @jewellery = Jewellery.new(jewellery_params)
    render :new, status: :bad_request
  end

  def destroy
    Jewellery.delete(params[:id])
    redirect_to admin_path
  end

  def edit
    @jewellery = Jewellery.find(params[:id])
  end

  def update
    @jewellery = Jewellery.find(params[:id])
    if @jewellery.update_attributes(jewellery_params)
      redirect_to admin_path
    else
      render :edit
    end
  end

  private

  def verify_required_params!
    jewellery_param = params.require(:jewellery)

    REQUIRED_PARAMS.each do |key|
      jewellery_param.require(key)
    end
  end

  def jewellery_params
    params.require(:jewellery).permit(PERMITTED_PARAMS)
  end
end
