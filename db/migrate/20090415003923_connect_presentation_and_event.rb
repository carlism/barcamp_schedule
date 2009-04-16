class ConnectPresentationAndEvent < ActiveRecord::Migration
  def self.up
    add_column :presentations, :event_id, :int
    Presentation.reset_column_information
    evt = Event.find_by_short_name "bcphl"
    Presentation.update_all("event_id = #{evt.id}")
  end

  def self.down
    remove_column :presentations, :event_id
  end
end
