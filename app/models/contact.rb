class Contact < ApplicationRecord
  # TODO: Think about it
  VALID_EMAIL_REGEX = /\A[^@]+@[^@]+\.[a-z]+\z/i

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
end
