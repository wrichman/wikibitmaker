class Article < ActiveRecord::Base
  has_one :discussion
  attr_accessible :text, :title
  after_create :create_discussion
end
