class AddOrderToRooms < ActiveRecord::Migration
  def self.up
    add_column :rooms, :order, :integer
  end

  def self.down
    remove_column :rooms, :order
  end
end
