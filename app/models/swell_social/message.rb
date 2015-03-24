module SwellSocial
	class Message < ActiveRecord::Base
		self.table_name = 'messages'

		enum status: { 'unread' => 1, 'read' => 2, 'archived' => 3, 'trash' => 4 }

		
	end
end