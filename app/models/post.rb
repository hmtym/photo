class Post < ApplicationRecord
  belongs_to :user
  has_many :post_images, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  def like_from?(user)
    self.post_likes.exists?(user_id: user.id)
  end
end
