class GalleriesController < ApplicationController
  before_filter -> { expires_in 10.minutes, public: true }

  def index
    @galleries = Gallery.all_names
  end

  def show
    @jewelleries = Jewellery.from_gallery(params[:id])
  end
end
