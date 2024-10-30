require "csv"


def import_books!
  books_file_path = Rails.root.join('test', 'fixtures', 'files', 'books.csv')


  book_counter = 0
  CSV.foreach(books_file_path, headers: true) do |book_info|
    book = Book.find_or_create_by!(title: book_info["title"], description: book_info["description"])
    book_counter += 1

    print '.'
    if !book.cover_img.attached?
      cover_img_path = Rails.root.join('test', 'fixtures', 'files', 'book_cover_images', "#{book_counter}.png")
      book.cover_img.attach(
        io: File.open(cover_img_path),
        filename: "#{book_counter}.png",
        content_type: 'image/png',
        identify: false
      )
    end

    # Автор книги:
    author_names = book_info["authors"].split(',')
    book_authors = []
    author_names.each do |author_name|
      book_authors << Author.find_or_create_by!(name: author_name.strip)
    end
    book.authors = book_authors

    # Жанр:
    genre_names = book_info["genre"].split(',')
    book_genres = []
    genre_names.each do |genre_name|
      book_genres << Genre.find_or_create_by!(name: genre_name.strip)
    end
    book.genres = book_genres
  end
end

def generate_users!
  min_date = 80.years.ago.to_date
  max_date = 18.years.ago.to_date

  300.times do |i|
    data = Faker::Internet.user(:username, :email, :password)

    data[:username] += "-#{i}"

    mailbox, domain = data[:email].split("@")
    data[:email] = "#{mailbox}-#{i}@#{domain}"

    User.create!(
      username: data[:username],
      email: data[:email],
      password: data[:password],
      date_of_birth: Date.jd(rand(min_date.jd..max_date.jd))
    )
    print '.'
  end
end

def insert_reviews!
  reviews_file_path = Rails.root.join('test', 'fixtures', 'files', 'reviews.csv')

  reviews = []
  CSV.foreach(reviews_file_path, headers: true) { |review_info| reviews << review_info }

  review_counter = 0

  all_books = Book.first(100).shuffle
  # Let first 25% of books have 1 review
  all_books[0..24].each do |book|
    create_one_review!(book, reviews[review_counter]["rating"], reviews[review_counter]["description"])
    review_counter += 1
  end

  all_books[25..49].each do |book|
    2.times do
      create_one_review!(book, reviews[review_counter]["rating"], reviews[review_counter]["description"])
      review_counter += 1
    end
  end

  all_books[50..74].each do |book|
    3.times do
      create_one_review!(book, reviews[review_counter]["rating"], reviews[review_counter]["description"])
      review_counter += 1
    end
  end

  all_books[75..89].each do |book|
    4.times do
      create_one_review!(book, reviews[review_counter]["rating"], reviews[review_counter]["description"])
      review_counter += 1
    end
  end

  Book.find_each { |book| book.recount_rating! }
end

def create_one_review!(book, rating, description)
  user = User.where.not(id: Review.where(book:).pluck(:user_id)).order("RANDOM()").first
  Review.create!(user:, book:, rating:, description:)
end

def import_articles!
  all_users = User.first(100)
  articles_file_path = Rails.root.join('test', 'fixtures', 'files', 'articles.csv')

  CSV.foreach(articles_file_path, headers: true) do |article_info|
    Article.create!(
      name: article_info["name"],
      content: article_info["content"],
      user: all_users.sample
    )
  end
end

def import_comments!
  all_users = User.first(100)
  all_articles = Article.first(100)
  article_comments_file_path = Rails.root.join('test', 'fixtures', 'files', 'article_comments.csv')
  CSV.foreach(article_comments_file_path, headers: true) do |comment_info|
    Comment.create!(
      commentable: all_articles.sample,
      content: comment_info["content"],
      user: all_users.sample
    )
  end

  all_books = Book.first(100)
  book_comments_file_path = Rails.root.join('test', 'fixtures', 'files', 'book_comments.csv')
  CSV.foreach(book_comments_file_path, headers: true) do |comment_info|
    Comment.create!(
      commentable: all_books.sample,
      content: comment_info["content"],
      user: all_users.sample
    )
  end
end

def create_pages!
  pages_file_path = Rails.root.join('test', 'fixtures', 'files', 'pages.csv')
  CSV.foreach(pages_file_path, headers: true) do |page_info|
    Page.create!(slug: page_info["slug"], content: page_info["content"])
  end
end

def create_admin!
  AdminUser.create!(email: 'admin@example.com', password: 'SeCuRePaSsWoRd')
end

import_books!

generate_users!   if !User.exists?
insert_reviews!   if !Review.exists?
import_articles!  if !Article.exists?
import_comments!  if !Comment.exists?
create_pages!     if !Page.exists?
create_admin!     if !AdminUser.exists?

puts "ready"
