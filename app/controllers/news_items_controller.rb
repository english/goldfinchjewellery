class NewsItemsController < ApplicationController
  def new
    @news_item = NewsItem.new
  end
end
