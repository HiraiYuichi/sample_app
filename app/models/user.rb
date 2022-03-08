class User < ApplicationRecord
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
  validates :password, presence: true, length: { minimum: 6 }
  end