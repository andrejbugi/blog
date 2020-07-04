class Article < ApplicationRecord
MINIMUM_TITLE_LENGTH = 5

  has_many :comments, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { minimum: 5, maximum: 40 }
end
