class Post < ActiveRecord::Base
  COORDINATE_DELTA = 0.05

  attr_accessible :body, :lat, :lng
  has_attached_file :image,
                  :styles => { :thumbnail => "100x100#" },
                  :storage => :s3,
                  :s3_credentials => S3_CREDENTIALS

  #belongs_to :user

  validates :body, presence: true, length: { maximum: 140 }
  #validates :user_id, presence: true
  validates :lat, :lng, :presence => true, :numericality => true

scope :nearby, lambda { |lat, lng|
  where("lat BETWEEN ? AND ?", lat - COORDINATE_DELTA, lat + COORDINATE_DELTA).
  where("lng BETWEEN ? AND ?", lng - COORDINATE_DELTA, lng + COORDINATE_DELTA).
  limit(64)
}

  def as_json(options = nil)
    {
      :lat => self.lat,
      :lng => self.lng,

      :image_urls => {
        :original => self.image.url,
        :thumbnail => self.image.url(:thumbnail)
      },

      :created_at => self.created_at.iso8601
    }
  end
end
 