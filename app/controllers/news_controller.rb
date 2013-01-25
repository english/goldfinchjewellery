class NewsController < ApplicationController
  def new
    @news_item = NewsItem.new
    @categories = NewsItem::CATEGORIES
  end

  def create
    if image_param.empty?
      @news_item = NewsItem.new(news_item_params)
    else
      s3image = S3image.new image_param['image']
      s3image.store!

      @news_item = NewsItem.new(news_item_params.merge(image_path: s3image.url))
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
  end

  private
  
  def news_item_params
    params.require(:news_item).permit [:category, :content]
  end

  def image_param
    params.require(:news_item).permit :image
  end
end
