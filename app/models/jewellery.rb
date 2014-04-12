class Jewellery < ActiveRecord::Base

  validates_presence_of :name, :description

  def self.from_gallery(gallery)
    where(gallery: gallery.titleize)
  end

  def self.categorised
    all.group_by(&:gallery)
  end
end
