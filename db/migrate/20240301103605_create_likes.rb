class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :micropost, foreign_key: true, null: false
      t.integer :like_id # Added like_id column

      t.timestamps
   
    end
  end
end