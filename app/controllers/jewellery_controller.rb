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
    Jewellery.destroy(params[:id])
    redirect_to jewellery_index_path
  end

  def create
    @jewellery = Jewellery.new(jewellery_params)

    if @jewellery.save
      redirect_to jewellery_index_path
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
end
