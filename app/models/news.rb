class News < ActiveRecord::Base
  CATEGORIES = ['Stockists', 'Events & Exhibitions', 'Awards', 'Press']

  validates :content, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  def self.categorised
    all.group_by(&:category)
  end

  def self.ordered
    order(updated_at: :desc)
  end

  def self.last_updated
    News.order('updated_at').last
  end
end
