class Task < ActiveRecord::Base
	
	belongs_to :user

	serialize :email, Array
	
	has_and_belongs_to_many :vms

end
