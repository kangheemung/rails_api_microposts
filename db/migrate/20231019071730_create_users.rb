class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
    # Adding index can improve lookup efficiency when querying relationships
    #効率のため、
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    #ゆーさー１人のおいて１回選択のため、記入
    # Optional: add an index that enforces uniqueness of the relationship to ensure a user can't follow another user more than once.
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
