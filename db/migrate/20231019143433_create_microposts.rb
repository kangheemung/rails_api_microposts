class CreateMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts do |t|
      t.string :title
      t.string :body
      t.string :user_id

      t.timestamps
    end
  end
end
