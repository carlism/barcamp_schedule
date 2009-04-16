class AddStartDateToTimeslots < ActiveRecord::Migration
  def self.up
    add_column :timeslots, :slot_date, :date
    remove_column :timeslots, :day
  end

  def self.down
    remove_column :timeslots, :slot_date
    add_column :timeslots, :day, :string
  end
end
