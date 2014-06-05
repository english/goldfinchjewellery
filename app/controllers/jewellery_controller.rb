class JewelleryController < ApplicationController
  before_action :authenticate, except: :index
  before_action :set_cors_headers, only: :index

  def index
    respond_to do |format|
      format.html do
        redirect_to new_session_path and return unless logged_in?
        @categorised_jewellery = Jewellery.categorised
      end

      format.json do
        render json: { jewellery: Jewellery.all }
      end
    end
  end

  def destroy
    jewellery = Jewellery.find(params[:id])
    S3::Delete.call(jewellery.image_path)
    jewellery.destroy

    redirect_to jewellery_index_path
  end

  def create
    @jewellery = Jewellery.new(jewellery_params.except(:image))
    render :new and return unless @jewellery.valid?

    @jewellery.image_path = S3::Put.call(jewellery_params.require(:image))
    @jewellery.save!

    redirect_to jewellery_index_path, notice: 'Jewellery Item saved successfully'
  end

  def new
    @jewellery = Jewellery.new
  end

  private

  def jewellery_params
    params.require(:jewellery).permit(:name, :description, :gallery, :image)
  end
end
