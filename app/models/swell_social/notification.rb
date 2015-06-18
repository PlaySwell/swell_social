module SwellSocial

	class Notification < ActiveRecord::Base
		self.table_name = 'notifications'

		enum status: { 'hidden' => 0, 'unnoticed' => 1, 'unread' => 2, 'read' => 3, 'archived' => 4, 'trash' => 5 }

		belongs_to		:user, class_name: SwellMedia.registered_user_class
		belongs_to		:actor, class_name: SwellMedia.registered_user_class
		belongs_to		:parent_obj, polymorphic: true
		belongs_to		:activity_obj, polymorphic: true

		def self.active
			where( status: [1,2,3] )
		end

		def self.not_read
			where( status: [1,2] )
		end

		def active?
			unnoticed? || unread? || read?
		end

	end

end