class RenameNewsItemsToNews < ActiveRecord::Migration
  def change
    rename_table :news_items, :news
  end
end
