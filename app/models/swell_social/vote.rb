module SwellSocial
	class Vote < ActiveRecord::Base
		self.table_name = 'votes'

		enum val: { 'down' => -1, 'up' => 1 }

		belongs_to	:user
		belongs_to	:parent_obj, polymorphic: true

		validates	:user_id, presence: true, uniqueness: { scope: [ :parent_obj_type, :parent_obj_id, :context ] }

		def self.by_context( context='like' )
			where( context: context )
		end

		def self.by_object( obj )
			where( parent_obj_type: obj.class.name, parent_obj_id: obj.id )
		end

		def self.by_user( user )
			where( user_id: user.id )
		end

		def self.likes
			self.up.by_context( 'like' )
		end



		def numeric_val
			self.read_attribute_before_type_cast( :val ).to_i
		end


		def update_parent_caches( args={} )
			if self.parent_obj.respond_to?( :cached_vote_count )

				upvotes = Vote.by_object( self.parent_obj ).up.count
				downvotes = Vote.by_object( self.parent_obj ).down.count
				totalvotes = upvotes + downvotes

				score = upvotes.to_f
				score = upvotes.to_f / totalvotes if totalvotes > 0

				self.parent_obj.update( cached_vote_count: totalvotes, cached_vote_score: score, cached_downvote_count: downvotes, cached_upvote_count: upvotes )

			end
		end

	
	end
end