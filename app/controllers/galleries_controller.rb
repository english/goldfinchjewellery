class GalleriesController < ApplicationController
  before_filter -> { expires_in 10.minutes, public: true }

  def index
  end

  def show
  end
end
