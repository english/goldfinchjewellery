class NewsController < ApplicationController
  def new
    @news_item = NewsItem.new
    @categories = NewsItem::CATEGORIES
  end

  def create
    @news_item = NewsItem.new(news_item_params)

    if @news_item.valid? && image_param
      s3image = S3::Put.new(image_param)
      s3image.execute

      @news_item.image_path = s3image.url
    end

    if @news_item.save
      redirect_to news_index_path, notice: 'News Item saved successfully'
    else
      @categories = NewsItem::CATEGORIES
      render :new
    end
  end

  def index
    @categorised_news_items = NewsItem.categorised
    fresh_when etag: [@categorised_news_items, session[:user_id]], public: true
  end

  def destroy
    NewsItem.find(params[:id]).destroy
    redirect_to news_index_path, notice: 'News Item deleted successfully'
  end

  private
  
  def news_item_params
    params.require(:news_item).permit [:category, :content]
  end

  def image_param
    params[:news_item][:image]
  end
end
