class NewsController < ApplicationController
  before_filter :authenticate, only: %i( create destroy )

  REQUIRED_PARAMS  = %i( content category )
  PERMITTED_PARAMS = %i( content category image )

  def new
    @news_item = NewsItem.new
    @categories = NewsItem::CATEGORIES
  end

  def create
    verify_required_params!

    NewsItem.create!(news_item_params)
    redirect_to admin_path, notice: 'News Item saved successfully'
  rescue ActionController::ParameterMissing, ActiveRecord::RecordInvalid => e
    @categories = NewsItem::CATEGORIES
    @news_item = NewsItem.new(news_item_params)
    @news_item.valid? # run validations

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
    params.require(:news_item).permit(PERMITTED_PARAMS)
  end
end
