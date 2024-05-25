class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_one_attached :profile_image

  validates :name, presence: true, length: {minimum:2, maximum:20}, uniqueness: true
  validates :introduction, length: {maximum:100}

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  #ゲスト関連
  def self.guest
    find_or_create_by!(email: ENV['GUEST_USER_EMAIL']) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
      user.introduction = "ゲストは閲覧のみです。"
    end
  end

  def guest_user?
    email == ENV['GUEST_USER_EMAIL']
  end

  #検索機能
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end
end
