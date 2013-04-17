 # This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all
Article.destroy_all
Discussion.destroy_all
Comment.destroy_all

@user = User.create(username: "mvleming", password: "password")
@article = Article.create(title: "Home", text: "This is going to be a long article.")
@discussion = @article.discussion
@discussion.comments.create(text: "Hello.", user_id: @user.id)
@discussion.comments.create(text: "Hi. How are you today?", user_id: @user.id)
@discussion.comments.create(text: "I'm great thank you for asking and yourself?", user_id: @user.id)
@discussion.comments.create(text: "I'm fantastic.", user_id: @user.id)