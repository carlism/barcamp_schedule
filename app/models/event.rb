class Event < ActiveRecord::Base
  has_many :timeslots
  has_many :rooms, :order => "order, name"
  has_many :presentations
  has_many :roles  
  has_many :users, :through => :roles
  has_many :admins, :through => :roles, :source => :user, :conditions => "role_type = '#{Role::TYPE_ADMIN}'" 

  def schedule(selected_day = nil)
    slots = []
    if selected_day
      slots = timeslots.find_all_by_slot_date(selected_day, :order=>'start_time')
    else
      slots = timeslots.find(:all, :order=>'slot_date, start_time')
    end
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

  def rotation_columns
    if rotation=='TIME_ACROSS'
      'time_column_heading'
    else
      'room_column_heading'
    end
  end
  
  def rotation_rows
    if rotation=='TIME_ACROSS'
      'time_rows'
    else
      'room_rows'
    end
  end
end
