class Discussion < ActiveRecord::Base
  belongs_to :article, dependent: :destroy
  has_many   :comments
  attr_accessible :article_id
end
