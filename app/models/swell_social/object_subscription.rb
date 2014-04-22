module SwellSocial

	class ObjectSubscription < ActiveRecord::Base
		self.table_name = 'object_subscriptions'

		belongs_to	:user
		belongs_to	:parent_obj, polymorphic: true 
		
	end
	
end