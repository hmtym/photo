class User < ApplicationRecord
    # データの保存前に、パスワードを暗号化するメソッド(convert_password)を実行するよう設定
  # before_save :convert_password
 before_create :convert_password
 
  # パスワードを暗号化するメソッド
  def convert_password
    self.password = User.generate_password(self.password)
  end
  def name123
    self.name + "123"
  end
  # パスワードをmd5に変換するメソッド
  def self.generate_password(password)
    # パスワードに適当な文字列を付加して暗号化する
    salt = "h!hgamcRAdh38bajhvgai17ysvb"
    Digest::MD5.hexdigest(salt + password)
  end
  

  # バリデーション
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      validates :name, presence: true
      validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: true
      validates :password, presence: true, length:{minimum: 6}
  
  
  # ユーザーがフォローされているかどうかを判定
  def followed_by?(user)
    user.follows.exists?(follow_user_id: self.id)
  end

  def follow_list
    @user = User.find(params[:id])
    @users = User.where(id: Follow.where(user_id: @user.id).pluck(:follow_user_id))
  end 
  
  def followered_by?(user)
    user.followers.exists?(follower_user_id: self.id)
  end
  def follower_list
    @user = User.find(params[:id])
    @users = User.where(id: Follower.where(user_id: @user.id).pluck(:follower_user_id))
  end
  # リレーション    
  has_many :posts
  has_many :post_likes
  has_many :post_comments
  has_many :follows
  has_many :followers, foreign_key: :follow_user_id, class_name: "Follow"
end
