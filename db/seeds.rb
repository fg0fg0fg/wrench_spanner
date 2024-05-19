# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.find_or_create_by!(email: "admin@gmail.com") do |admin|
  admin.password = ENV['ADMIN_PASSWORD']
end

tanaka = User.find_or_create_by!(email: "123456@yahoo.co.jp") do |user|
  user.name = "田中"
  user.password = "123456"
  user.introduction = "DIYをやっています"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
end

tarako = User.find_or_create_by!(email: "111111@yahoo.co.jp") do |user|
  user.name = "鱈子"
  user.password = "111111"
  user.introduction = "工場勤務"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")
end

nigou = User.find_or_create_by!(email: "222222@yahoo.co.jp") do |user|
  user.name = "二号"
  user.password = "222222"
  user.introduction = "一号！"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")
end

worktool = Genre.find_or_create_by!(name: "作業工具")

electrictool = Genre.find_or_create_by!(name: "電動工具")

pneumatictool = Genre.find_or_create_by!(name: "空圧工具")


hako = Post.find_or_create_by!(title: "持ち運びしやすい、〇〇メーカー") do |post|
  post.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"), filename:"sample-post1.jpg")
  post.body = "整理整頓がしやすく使いかってがよい。必要なものを見つけやすい"
  post.user = tanaka
  post.star = "1"
  post.genre = worktool
end

ahlen = Post.find_or_create_by!(title: "バイク等のねじ締め") do |post|
  post.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.jpg"), filename:"sample-post2.jpg")
  post.body = "長いので軽い力で締められますが、長すぎて邪魔になる場合もありますので購入時には注意が必要かもしれません。"
  post.user = tanaka
  post.star = "4"
  post.genre = worktool
end

Comment.find_or_create_by!(body: "取り出しやすいけど耐久に難あり") do |comment|
  comment.post = hako
  comment.user = tanaka
end

aaa = Tag.find_or_create_by!(name: "A")
bbb = Tag.find_or_create_by!(name: "B")

PostTag.find_or_create_by!(tag: aaa, post: hako)
PostTag.find_or_create_by!(tag: bbb, post: ahlen)