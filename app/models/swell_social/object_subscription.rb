module SwellSocial

	class ObjectSubscription < ActiveRecord::Base
		self.table_name = 'object_subscriptions'

		enum status: { 'active' => 0, 'deleted' => 1 }
		enum availability: { 'just_me' => 0, 'anyone' => 1 }

		belongs_to	:user
		belongs_to	:parent_obj, polymorphic: true 

		
	end
	
end