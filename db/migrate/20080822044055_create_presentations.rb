class CreatePresentations < ActiveRecord::Migration
  def self.up
    create_table :presentations do |t|
      t.string :title
      t.string :presenter
      t.string :presenter_email
      t.integer :room_id
      t.integer :timeslot_id

      t.timestamps
    end
    add_index(:presentations, [:room_id, :timeslot_id], :unique=>true)
  end

  def self.down
    drop_table :presentations
  end
end
