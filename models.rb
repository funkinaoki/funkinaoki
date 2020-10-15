require 'bundler/setup'
Bundler.require

if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
  has_secure_password
  has_many :questions
end

class Question < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  belongs_to :list
end

class Senmonka < ActiveRecord::Base
  has_secure_password
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :question
  belongs_to :senmonka
end

class List < ActiveRecord::Base
  has_many :questions
end