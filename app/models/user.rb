class User < ApplicationRecord
  MAXIMUM_NAME_LENGTH = 255
  MAXIMUM_EMAIL_LENGTH = 50
  MINIMUM_PASSWORD_LENGTH = 6
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  MINIMUM_AGE = 18

  has_secure_password

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :profile_picture

  has_many :authored_conversations, class_name: 'Conversation', foreign_key: 'author_id'
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'received_id'
  has_many :personal_messages, dependent: :destroy

  before_save :email_to_downcase

  validates :name, presence: true, length: { maximum: MAXIMUM_NAME_LENGTH }

  validates :email, presence: true, length: { maximum: MAXIMUM_EMAIL_LENGTH },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: MINIMUM_PASSWORD_LENGTH }

  validates :age, presence: true

  validate :at_least_18

  private

  def email_to_downcase
    self.email = email.downcase
  end

  def at_least_18
    errors.add(:age, 'must be at least 18') if age < MINIMUM_AGE
  end
end
