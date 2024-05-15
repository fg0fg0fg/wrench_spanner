class Post < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  has_one_attached :post_image

  validates :title, presence: true
  validates :body, presence: true

  def get_post_image
    (post_image.attached?) ? post_image : 'no_image.jpg'
  end

  #検索機能
  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(title: content)
    elsif method == 'forward'
      Post.where('title LIKE ?', content + '%')
    elsif method == 'backward'
      Post.where('title LIKE ?', '%' + content)
    else
      Post.where('title LIKE ?', '%' + content + '%')
    end
  end

  #タグ機能
  def save_tags(tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    new_tags.each do |new|
      tag = Tag.find_or_create_by(name: new)
      unless self.tags.include?(tag)
        self.tags << tag
      end
    end
  end



  # def save_tags(latest_tags)
  #   if self.tags.empty?
  #     latest_tags.each do |latest_tag|
  #       self.tags.find_or_create_by(name: latest_tag)
  #     end
  #   elsif latest_tags.empty?


  #     self.tags.each do |tag|
  #       self.tags.delete(tag)
  #     end
  #   else
  #     current_tags = self.tags.pluck(:name)

  #     old_tags = current_tags - latest_tags

  #     new_tags = latest_tags - current_tags

  #     old_tags.each do |old_tag|
  #       tag = self.tags.find_by(name: old_tag)
  #       self.tags.delete(tag) if tag.present?
  #     end


  #     new_tags.each do |new_tag|

  #       self.tags.find_or_create_by(name: new_tag)
  #     end
  #   end
  # end

end
