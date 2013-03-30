class JewelleriesController < ApplicationController
  before_filter :authenticate

  REQUIRED_PARAMS  = %i( name description gallery image )
  PERMITTED_PARAMS = %i( name description gallery image_path )

  def new
    @jewellery = Jewellery.new
  end

  def create
    verify_required_params!
    options = jewellery_params

    s3_image = S3::Put.new(params[:jewellery][:image])
    s3_image.execute
    options.merge!(image_path: s3_image.url)

    Jewellery.create!(options.except(:image))
    redirect_to admin_path
  rescue ActionController::ParameterMissing, ActiveRecord::RecordInvalid => e
    @jewellery = Jewellery.new(jewellery_params)
    @jewellery.valid? # force error building
    render :new, status: :bad_request
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
