module SwellSocial

	class Notification < ActiveRecord::Base
		self.table_name = 'notifications'

		enum status: { 'unread' => 1, 'read' => 2, 'archived' => 3, 'trash' => 4 }

		belongs_to		:user, class_name: SwellMedia.registered_user_class
		belongs_to		:actor, class_name: SwellMedia.registered_user_class
		belongs_to		:user_event
		#belongs_to		:regarding_obj, polymorphic: true

	end

end