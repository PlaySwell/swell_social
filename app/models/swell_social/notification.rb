module SwellSocial
	class Notification < ActiveRecord::Base
		self.table_name = 'notifications'

		belongs_to :user

	end
end