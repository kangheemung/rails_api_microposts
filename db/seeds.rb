# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
microposts = [] # 空の配列を作成

10000.times do |n| # 10000回の繰り返しを行うループ
  title = Faker::Lorem.sentence(word_count: 5) # ランダムな5単語で構成されるタイトルを生成
  body = Faker::Lorem.sentence(word_count: 100) # ランダムな100単語で構成される本文を生成
  user_id = User.pluck(:id).sample # Userモデルからランダムなuser_idを取得

  # タイトルと本文とuser_idを使用してMicropostオブジェクトを作成し、データベースに保存する
  micropost = Micropost.create(title: title, body: body, user_id: user_id)
  # タイトルと本文をハッシュとして作成し、配列に追加する
  microposts << micropost
  #microposts << { title: title, body: body }
  puts "#{n} create done"
end

# `insert_all`メソッドを使用して、`posts`配列の要素を一括でデータベースに挿入する

#Micropost.insert_all(microposts) #rails 6以上使用可能
#Micropost.create(microposts)