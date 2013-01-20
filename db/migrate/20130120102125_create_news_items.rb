class CreateNewsItems < ActiveRecord::Migration
  def change
    create_table :news_items do |t|
      t.text :content
      t.string :category

      t.timestamps
    end
  end
end
