class Comment < ApplicationRecord
  include PoliticalFilter
  belongs_to :user
  belongs_to :post
  validates :body, presence: true
end
