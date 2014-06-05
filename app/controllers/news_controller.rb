class NewsController < ApplicationController
  before_action :authenticate, except: :index
  before_action :set_cors_headers, only: :index

  def new
    @news = News.new
  end

  def create
    @news = News.new(news_params.except(:image))
    render :new, status: :bad_request and return unless @news.valid?

    @news.image_path = S3::Put.call(news_params.require(:image))
    @news.save!

    redirect_to root_path, notice: 'News Item saved successfully'
  end

  def index
    respond_to do |format|
      format.json do
        render json: { news: News.all.map(&method(:render_news_item)) }
      end

      format.html do
        redirect_to new_session_path and return unless logged_in?
        @categorised_news = News.ordered.categorised
      end
    end
  end

  def destroy
    news_item = News.find(params[:id])

    S3::Delete.call(news_item.image_path)
    news_item.destroy

    redirect_to root_path, notice: 'News Item deleted successfully'
  end

  private

  def render_news_item(news_item)
    {
      id:        news_item.id,
      category:  news_item.category,
      html:      render_to_string(partial: "news/news_item.html.erb", locals: { news_item: news_item }),
      updatedAt: news_item.updated_at
    }
  end

  def news_params
    params.require(:news).permit(%i( content category image ))
  end
end
