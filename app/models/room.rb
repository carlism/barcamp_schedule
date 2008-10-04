class Room < ActiveRecord::Base
  validates_presence_of :name, :location
  has_many :presentations
end
