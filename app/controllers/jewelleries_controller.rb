class JewelleriesController < ApplicationController
  before_filter :authenticate

  def new
    @jewellery = Jewellery.new
  end

  def create
    options = params.require(:jewellery).permit(%i( name description gallery ))

    if params[:jewellery][:image]
      s3_image = S3::Put.new(params[:jewellery][:image])
      s3_image.execute
      options.merge!(image_path: s3_image.url)
    end

    @jewellery = Jewellery.new(options)

    if @jewellery.save
      redirect_to admin_path
    else
      render :new
    end
  end

  private

  def jewellery_params
    params.require(:jewellery).permit(%i( name description gallery ))
  end
end
