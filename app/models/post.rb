class Post < ActiveRecord::Base
  validates :body, :presence => true
  validates :title, :presence => true

  has_and_belongs_to_many :tags

  self.per_page = 3
end
