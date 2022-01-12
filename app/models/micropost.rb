class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :recent_posts, ->{order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.settings.content_maximum}
  validates :image,
            content_type: {
              in: Settings.settings.image_type,
              message: I18n.t("invalid_format")
            },
            size: {
              less_than: Settings.settings.max_image_size.megabytes,
              message: I18n.t("large_size")
            }

  def display_image image
    image.variant(resize: Settings.settings.resize_images).processed
  end
end
