class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :short_name
      t.string :image_url
      t.string :link_url
      t.string :primary_color
      t.string :secondary_color
      t.string :tertiary_color

      t.timestamps
    end
    
    Event.reset_column_information
    evt = Event.create :name=>'BarCamp Philly', 
      :short_name=>'bcphl',
      :image_url=>'http://www.barcampphilly.org/images/barcamp_badge_250px.png',
      :link_url=>'http://www.barcampphilly.org/',
      :primary_color=>'rgb(0, 63, 131)',
      :secondary_color=>'white',
      :tertiary_color=>'rgb(204,204,204)'
    add_column :rooms, :event_id, :int
    Room.reset_column_information
    Room.update_all("event_id = #{evt.id}")
    
    add_column :timeslots, :event_id, :int    
    Timeslot.reset_column_information
    Timeslot.update_all("event_id = #{evt.id}")
  end

  def self.down
    remove_column :timeslots, :event_id
    remove_column :rooms, :event_id
    remove_column :presentation, :event_id
    drop_table :events
  end
end
