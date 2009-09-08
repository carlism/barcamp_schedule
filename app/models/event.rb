class Event < ActiveRecord::Base
  has_many :timeslots
  has_many :rooms
  has_many :presentations
  
  def schedule(selected_day)
    slots = timeslots.find_all_by_slot_date(selected_day, :order=>'start_time')
    @grid = []
    slots.each do
      row = []
      rooms.each do
        row << ""
      end
      @grid << row
    end
    presentations.each do |presentation|
      room_index = rooms.index(presentation.room)
      timeslot_index = slots.index(presentation.timeslot)
      if( room_index and timeslot_index )
        @grid[timeslot_index][room_index] = presentation
      end
    end
    [rooms, slots, @grid]
  end
  
  def days
    timeslots.find(:all, :select=>'distinct slot_date').map{|ts| ts.slot_date }
  end
end
