class User < ApplicationRecord
#:remember_token属性を定義
  attr_accessor :remember_token


     #saveの直前に　現在のユーザーのemailに　emailを小文字にしたものを代入
  #Userモデルの中ではself.email = self.email.downcaseの右側のselfは省略できる
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  #passwordの検証　存在　→　true,　長さ　→　最小6
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

   # 渡された文字列のハッシュ値を返す
   def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
   # 永続セッションのためにユーザーをデータベースに記憶する
   def remember
    #remember_tokenに　User.new_tokenを代入
    self.remember_token = User.new_token
    #validationを無視して更新　（:remember_digest属性にハッシュ化したremember_tokenを）
    update_attribute(:remember_digest, User.digest(remember_token))
  end
   # 渡されたトークンがダイジェストと一致したらtrueを返す
   def authenticated?(remember_token)
       #記憶ダイジェストがnilの場合にfalseを返す
       return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

    # ユーザーのログイン情報を破棄する
    def forget
      update_attribute(:remember_digest, nil)
    end

  end