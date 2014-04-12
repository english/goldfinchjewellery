class NewsController < ApplicationController
  before_action :authenticate, except: :index
  before_action :set_categories, only: %i( new create )

  def new
    @news = News.new
  end

  def create
    @news = News.new(news_params.except(:image))

    if @news.valid?
      @news.image_path = s3_putter.call(news_params.require(:image))
      @news.save!
      redirect_to root_path, notice: 'News Item saved successfully'
    else
      render :new, status: :bad_request
    end
  end

  def index
    respond_to do |format|
      format.json do
        response.headers["Access-Control-Allow-Origin"] = "*"

        render json: {
          news: News.all.map { |news_item|
            {
              id: news_item.id,
              category: news_item.category,
              html: render_to_string(partial: "news/news_item.html.erb", locals: { news_item: news_item, admin: false }),
              updatedAt: news_item.updated_at
            }
          }
        }
      end

      format.html do
        if logged_in?
          @categorised_news = News.ordered.categorised
        else
          redirect_to new_session_path
        end
      end
    end
  end

  def destroy
    news_item = News.find(params[:id])
    s3_deleter.call(news_item.image_path)
    news_item.destroy

    redirect_to root_path, notice: 'News Item deleted successfully'
  end

  private

  def news_params
    params.require(:news).permit(%i( content category image ))
  end

  def set_categories
    @categories = News::CATEGORIES
  end

  def s3_putter
    S3::Put
  end

  def s3_deleter
    S3::Delete
  end
end
