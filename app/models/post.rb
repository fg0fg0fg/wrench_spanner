class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy

  has_one_attached :post_image

  validates :title, presence: true
  validates :body, presence: true

  def get_post_image
    (post_image.attached?) ? post_image : 'no_image.jpg'
  end
end
