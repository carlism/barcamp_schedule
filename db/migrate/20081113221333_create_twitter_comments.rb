class CreateTwitterComments < ActiveRecord::Migration
  def self.up
    add_column :presentations, :tweet_hash, :string
    add_column :presentations, :tweet_max_id, :string
  end

  def self.down
    remove_column :presentations, :tweet_hash
    remove_column :presentations, :tweet_max_id    
  end
end

