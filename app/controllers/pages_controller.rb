class PagesController < ApplicationController
  before_action -> { expires_in 30.minutes, public: true }, :except => :admin

  def about;   end
  def contact; end
  def links;   end

  def admin
    redirect_to new_session_path unless logged_in?
    @categorised_news = News.categorised
    @categorised_jewellery = Jewellery.categorised
  end
end
