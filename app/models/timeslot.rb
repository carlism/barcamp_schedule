class Timeslot < ActiveRecord::Base
  validates_presence_of :start_time
  has_many :presentations
  belongs_to :event
end
