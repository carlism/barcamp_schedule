class Timeslot < ActiveRecord::Base
  validates_presence_of :day, :start_time
  has_many :presentations
end
