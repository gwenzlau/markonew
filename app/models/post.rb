class Post < ActiveRecord::Base
  attr_accessible :body, :lat, :lng
  has_attached_file :image,
                  :styles => { :thumbnail => "100x100#" },
                  :storage => :s3,
                  :s3_credentials => S3_CREDENTIALS

  belongs_to :user

  validates :body, presence: true, length: { maximum: 140 }
  #validates :user_id, presence: true
  #validates :lat, presence: true,
  #validates :lng, presence: true

  default_scope order: 'posts.created_at DESC'

  COORDINATE_DELTA = 0.05

scope :nearby, lambda { |lat, lng|
  where("lat BETWEEN ? AND ?", lat - COORDINATE_DELTA, lat + COORDINATE_DELTA).
  where("lng BETWEEN ? AND ?", lng - COORDINATE_DELTA, lng + COORDINATE_DELTA).
  limit(64)
}
end
 