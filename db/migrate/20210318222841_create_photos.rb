class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.string :image
      t.integer :owner_id
      t.integer :likes_count
      t.integer :comments_count
      t.text :caption

      t.timestamps
    end
  end
end
