class RenameImageToImagePathOnNewsItems < ActiveRecord::Migration
  def change
    rename_column :news_items, :image, :image_path
  end
end
