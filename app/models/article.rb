class Article < ApplicationRecord
  belongs_to :user
  has_one_attached :cover_img

  has_many :comments, as: :commentable, dependent: :destroy
end
