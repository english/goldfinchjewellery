class NewsController < ApplicationController
  def new
    @news_item = NewsItem.new
    @categories = NewsItem::CATEGORIES
  end

  def create
    s3image = S3Image.new image_param
    s3image.store!

    @news_item = NewsItem.new(news_item_params.merge(image_path: s3image.url))

    if @news_item.save
      redirect_to news_index_path, notice: 'News Item saved successfully'
    else
      @categories = NewsItem::CATEGORIES
      render :new
    end
  end

  def index
    @categorised_news_items = NewsItem.categorised
  end

  private
  
  def news_item_params
    params.require(:news_item).permit [:category, :content]
  end

  def image_param
    params.require(:news_item).permit :image_path
  end
end
