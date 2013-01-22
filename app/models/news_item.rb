class NewsItem < ActiveRecord::Base
  CATEGORIES = ['Stockists', 'Events & Exhibitions', 'Awards', 'Press']

  validates :content, presence: true
  validates :category, presence: true #, inclusion: { in: CATEGORIES }

  def self.categorised
    all.group_by &:category
  end
end
