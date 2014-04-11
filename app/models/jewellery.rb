require "s3/put"

class Jewellery < ActiveRecord::Base
  attr_accessor :image

  validates_presence_of :name, :description
  validates_presence_of :image, on: :create

  before_save :upload_image, :if => :image

  def self.from_gallery(gallery)
    where(gallery: gallery.titleize)
  end

  def self.categorised
    all.group_by(&:gallery)
  end

  private

  def upload_image
    self.image_path = s3_putter(image).call
  end

  def s3_putter(file)
    S3::Put.new(file)
  end
end
