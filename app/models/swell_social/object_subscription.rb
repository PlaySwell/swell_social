module SwellSocial

	class ObjectSubscription < ActiveRecord::Base
		self.table_name = 'object_subscriptions'

		enum status: { 'active' => 1, 'deleted' => 2 }
		enum availability: { 'just_me' => 1, 'anyone' => 2 }

		belongs_to	:user
		belongs_to	:parent_obj, polymorphic: true 

		
	end
	
end