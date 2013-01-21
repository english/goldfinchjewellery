class NewsController < ApplicationController
  def new
    @news_item = NewsItem.new
  end

  def create
    attributes = params.require(:news_item).permit [:category, :content]
    NewsItem.create attributes
    redirect_to news_index_path
  end

  def index
    @categorised_news_items = NewsItem.categorised
  end
end
