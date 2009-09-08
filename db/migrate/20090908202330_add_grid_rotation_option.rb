class AddGridRotationOption < ActiveRecord::Migration
  def self.up
    add_column :events, :rotation, :string, :null=>false, :default=>"TIME_ACROSS"
  end

  def self.down
    remove_column :events, :rotation
  end
end
