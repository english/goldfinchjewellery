class NewsItem < ActiveRecord::Base
  CATEGORIES = ['Stockists', 'Events & Exhibitions', 'Awards', 'Press']

  validates :content, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  after_destroy :delete_image

  def self.categorised
    all.group_by &:category
  end

  def self.last_updated
    NewsItem.order('updated_at').last
  end

  private

  def delete_image
    S3::Delete.new(image_path).execute if image_path.present?
  end
end
