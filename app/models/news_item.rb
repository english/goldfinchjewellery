class NewsItem < ActiveRecord::Base
  CATEGORIES = ['Stockists', 'Events & Exhibitions', 'Awards', 'Press']

  validates :content, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  after_destroy :delete_image

  def self.categorised
    all.group_by &:category
  end

  private

  def delete_image
    S3Delete.new(image_path).execute if image_path.present?
  end
end
