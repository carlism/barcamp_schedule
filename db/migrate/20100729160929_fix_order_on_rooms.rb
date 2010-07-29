class FixOrderOnRooms < ActiveRecord::Migration
  def self.up
        rename_column :rooms, :order, :item_order
  end

  def self.down
        rename_column :rooms, :item_order, :order
  end
end
