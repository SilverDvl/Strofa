class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :book_genres, dependent: :destroy
  has_many :genres, through: :book_genres

  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors

  has_many :comments, as: :commentable, dependent: :destroy

  has_one_attached :cover_img

  # TODO: Move to service object
  def recount_rating!
    # NOTE: No rating if no reviews
    return if reviews.blank?

    self.rating = reviews.average(:rating).to_f
    save!
  end
end
