class CreateJewelleries < ActiveRecord::Migration
  def change
    create_table :jewelleries do |t|
      t.string :name
      t.text   :description
      t.string :gallery
      t.string :image_path

      t.timestamps
    end
  end
end
