class NewsItem < ActiveRecord::Base
  CATEGORIES = ['Stockists', 'Events & Exhibitions', 'Awards', 'Press']

  def self.categorised
    all.group_by &:category
  end
end
