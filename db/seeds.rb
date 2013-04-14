 # This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@user = User.create(username: "mvleming", password: "password")
@article = Article.create(title: "Home", text: "Blah Blah Blah Blah Tommy is so tired")
@discussion = @article.create_discussion
@discussion.comments.create(text: "Hello.", user_id: @user.id)
@discussion.comments.create(text: "Hi. How are you today?", user_id: @user.id)
@discussion.comments.create(text: "I'm great thank you for asking and yourself?", user_id: @user.id)
@discussion.comments.create(text: "I'm fantastic.", user_id: @user.id)