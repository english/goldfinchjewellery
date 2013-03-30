class Jewellery < ActiveRecord::Base
  validates_presence_of :image_path, :name, :description

  def self.from_gallery(gallery)
    where(gallery: gallery.titleize)
  end
end
