class Article < ActiveRecord::Base
  has_one :discussion
  attr_accessible :text, :title
end
