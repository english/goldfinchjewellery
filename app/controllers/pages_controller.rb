class PagesController < ApplicationController
  before_filter -> { expires_in 30.minutes, public: true }, :except => :admin

  def about
  end

  def contact
  end

  def links
  end

  def admin
    redirect_to new_session_path unless logged_in?
    @categorised_news_items = NewsItem.categorised
    @galleries = Gallery.all_names
  end
end
