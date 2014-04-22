module SwellSocial
	class Vote < ActiveRecord::Base
		self.table_name = 'votes'

		belongs_to	:user
		belongs_to	:votable, polymorphic: true

		validates	:user_id, presence: true, uniqueness: { scope: [ :votable_type, :votable_id ] }
	
	end
end