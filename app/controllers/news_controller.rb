class NewsController < ApplicationController
  before_filter :authenticate, only: %i( create destroy )

  REQUIRED_PARAMS  = %i( content category )
  PERMITTED_PARAMS = %i( content category image_path )

  def new
    @news_item = NewsItem.new
    @categories = NewsItem::CATEGORIES
  end

  def create
    verify_required_params!
    options = news_item_params

    if params[:news_item][:image]
      s3_image = S3::Put.new(params[:news_item][:image])
      s3_image.execute

      options.merge!(image_path: s3_image.url)
    end

    NewsItem.create!(options)
    redirect_to admin_path, notice: 'News Item saved successfully'
  rescue ActionController::ParameterMissing, ActiveRecord::RecordInvalid => e
    @categories = NewsItem::CATEGORIES
    @news_item = NewsItem.new(params.require(:news_item).permit(REQUIRED_PARAMS))
    @news_item.valid? # force error building
    render :new, status: :bad_request
  end

  def index
    fresh_when(NewsItem.last_updated)
    @categorised_news_items = NewsItem.categorised
  end

  def destroy
    NewsItem.find(params[:id]).destroy
    redirect_to admin_path, notice: 'News Item deleted successfully'
  end

  private

  def verify_required_params!
    news_item_param = params.require(:news_item)

    REQUIRED_PARAMS.each do |key|
      news_item_param.require(key)
    end
  end
  
  def news_item_params
    params.require(:news_item).permit PERMITTED_PARAMS
  end
end
