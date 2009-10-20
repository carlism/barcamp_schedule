class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :role_type

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
