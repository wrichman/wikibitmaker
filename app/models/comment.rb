class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :discussion, dependent: :destroy
  attr_accessible :text, :user_id
end
