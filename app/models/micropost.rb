class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :newest, ->{order(created_at: desc)}
  validates :user_id, presence: true
  validates :content, presence: true,
      length: {maximum: Settings.validates.max_content}
  validates :image, content_type: {in: Settings.micropost.image_type,
                                   message: :validate_type},
                    size: {less_than: Settings.validates.min_store.megabytes,
                           message: :size_message}

  scope :newest, ->{order(created_at: :desc)}
  def display_image
    image.variant(resize_to_limit: Settings.micropost.resize_to_limit)
  end
end
