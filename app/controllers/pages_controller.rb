class PagesController < ApplicationController
  before_filter -> { expires_in 10.minutes, public: true }

  def about
  end

  def contact
  end

  def links
  end
end
