module SwellSocial
	class Notification
		self.table_name = 'notifications'

		belongs_to :user

	end
end