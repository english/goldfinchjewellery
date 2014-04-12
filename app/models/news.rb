require "s3/put"

class News < ActiveRecord::Base
  CATEGORIES = ['Stockists', 'Events & Exhibitions', 'Awards', 'Press']

  attr_accessor :image

  validates :content, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  before_save   :upload_image, :if => :image
  after_destroy :delete_image, :if => :image_path

  def self.categorised
    all.group_by(&:category)
  end

  def self.ordered
    order(updated_at: :desc)
  end

  def self.last_updated
    News.order('updated_at').last
  end

  private

  def delete_image
    S3::Delete.new(image_path).call
  end

  def upload_image
    self.image_path = s3_putter.call(image)
  end

  def s3_putter
    S3::Put
  end
end
