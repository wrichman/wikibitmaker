class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :comments
  # attr_accessible :title, :body
end
