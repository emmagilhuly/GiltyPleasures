class Post < ActiveRecord::Base
  has_many :comments
  validates_presence_of :body, :title
  has_many :post_attachments
  accepts_nested_attributes_for :post_attachments
end
