class User < ActiveRecord::Base
  acts_as_authentic
  has_many :roles  
  has_many :events, :through => :roles
end
