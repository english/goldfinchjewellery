class NewsController < ApplicationController
  def new
    @news_item = NewsItem.new
  end

  def create
    attributes = params.require(:news_item).permit [:category, :content]
    @news_item = NewsItem.new attributes

    if @news_item.save
      redirect_to news_index_path, notice: 'News Item saved successfully'
    else
      render :new
    end
  end

  def index
    @categorised_news_items = NewsItem.categorised
  end
end
