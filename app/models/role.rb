class Role < ActiveRecord::Base
    belongs_to :user
    belongs_to :event

    TYPE_ADMIN = 'admin'
end
