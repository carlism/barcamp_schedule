class Comment < ActiveRecord::Base
  belongs_to :presentation
  validates_presence_of :body
end
