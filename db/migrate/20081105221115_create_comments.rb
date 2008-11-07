class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :presentation_id
      t.string :name
      t.text :body
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
