class NewsController < ApplicationController
  before_action :authenticate,   only: %i( create destroy )
  before_action :set_categories, only: %i( new create )

  def new
    @news = News.new
  end

  def create
    @news = News.new(news_params)

    if @news.save
      redirect_to admin_path, notice: 'News Item saved successfully'
    else
      render :new, status: :bad_request
    end
  end

  def index
    fresh_when(News.last_updated)
    @categorised_news = News.categorised
  end

  def destroy
    News.find(params[:id]).destroy
    redirect_to admin_path, notice: 'News Item deleted successfully'
  end

  private

  def news_params
    params.require(:news).permit(%i( content category image ))
  end

  def set_categories
    @categories = News::CATEGORIES
  end
end
