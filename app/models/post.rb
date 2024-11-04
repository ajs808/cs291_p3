class Post < ApplicationRecord
  include PoliticalFilter
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true
end