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

				if Vote.by_object( self.parent_obj ).count == 0
					score = 0
				else
					score = Vote.by_object( self.parent_obj ).up.count / Vote.by_object( self.parent_obj ).count
				end

				updates = { cached_vote_count: Vote.by_object( self.parent_obj ).count, cached_vote_score: score }

				if args[:dir] == 'up'
					# we're flipping, so remove old downvote
					updates.merge!( cached_downvote_count: parent_obj.cached_downvote_count - 1 )
				elsif args[:dir] == 'down'
					# flipping to down, remove old upvote
					updates.merge!( cached_upvote_count: parent_obj.cached_upvote_count - 1 )
				end

				if not( self.persisted? )
					# vote was deleted, decrement appropriate count
					if self.up?
						updates.merge!( cached_upvote_count: parent_obj.cached_upvote_count - 1 )
					else
						updates.merge!( cached_downvote_count: parent_obj.cached_downvote_count - 1 )
					end
				end

				self.parent_obj.update( updates )	

			end
		end

	
	end
end