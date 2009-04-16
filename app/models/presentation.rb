class Presentation < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :room_id, :scope => :timeslot_id
  validates_format_of :presenter_email, :with=>/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on=>:create, :allow_blank=>true
  belongs_to :room
  belongs_to :timeslot
  belongs_to :event
  has_many :comments, :order=>"comments.created_at desc"
end
