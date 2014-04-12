class JewelleryController < ApplicationController
  before_action :authenticate, except: :index

  def index
    respond_to do |format|
      format.html do
        if logged_in?
          @categorised_jewellery = Jewellery.categorised
        else
          redirect_to new_session_path
        end
      end

      format.json do
        response.headers["Access-Control-Allow-Origin"] = "*"
        render json: { jewellery: Jewellery.all }
      end
    end
  end

  def destroy
    jewellery = Jewellery.find(params[:id])
    s3_deleter.call(jewellery.image_path)
    jewellery.destroy
    redirect_to jewellery_index_path
  end

  def create
    @jewellery = Jewellery.new(jewellery_params.except(:image))

    if @jewellery.valid?
      @jewellery.image_path = s3_putter.call(jewellery_params.require(:image))
      @jewellery.save!
      redirect_to jewellery_index_path, notice: 'Jewellery Item saved successfully'
    else
      render :new
    end
  end

  def new
    @jewellery = Jewellery.new
  end

  private

  def jewellery_params
    params.require(:jewellery).permit(:name, :description, :gallery, :image)
  end

  def s3_putter
    S3::Put
  end

  def s3_deleter
    S3::Delete
  end
end
