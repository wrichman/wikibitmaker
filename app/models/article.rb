class Article < ActiveRecord::Base
  has_one :discussion
  attr_accessible :text, :title
  after_save :create_discussion
end
