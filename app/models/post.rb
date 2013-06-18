class Post < ActiveRecord::Base
  attr_accessible :body

  belongs_to :user

  validates :body, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  #validates :lat, presence: true,
  #validates :lng, presence: true

  default_scope order: 'posts.created_at DESC'
end
 