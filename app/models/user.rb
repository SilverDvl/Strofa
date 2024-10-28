class User < ApplicationRecord
  has_many :reviews,  dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_secure_password

  # NOTE: Auxilary method for getting user's age
  def age
    return if date_of_birth.blank?

    today = Date.today
    age = today.year - date_of_birth.year
    age -= 1 if today < date_of_birth + age.years
    age
  end
end
