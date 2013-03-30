class Jewellery < ActiveRecord::Base
  attr_accessor :image

  validates_presence_of :image, :name, :description

  before_save :upload_image

  def self.from_gallery(gallery)
    where(gallery: gallery.titleize)
  end

  private

  def upload_image
    s3_image = S3::Put.new(self.image)
    s3_image.execute
    self.image_path = s3_image.url
  end
end
