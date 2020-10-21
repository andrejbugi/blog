class Article < ApplicationRecord
MINIMUM_TITLE_LENGTH = 5
MAXIMUM_TITLE_LENGTH = 40

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { minimum: MINIMUM_TITLE_LENGTH, maximum: MAXIMUM_TITLE_LENGTH }
end
