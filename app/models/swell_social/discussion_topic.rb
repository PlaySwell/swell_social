module SwellSocial
	class DiscussionTopic < UserPost


		include FriendlyId
		friendly_id :slugger, use: :slugged



		def discussion
			self.parent_obj
		end

		def last_post
			self.posts.order( created_at: :desc ).first
		end

		def paginated_page( dir='asc', per_page=25 ) # todo -- finish implementing reverse
			priors = DiscussionTopic.active.where( parent_obj_id: self.parent_obj_id ).where( "created_at < :my_created_at", my_created_at: self.created_at ).count
			page = ( priors / per_page ) + 1
		end

		def posts
			DiscussionPost.where( parent_obj_id: self.id, parent_obj_type: self.class.name.demodulize )
		end

		def slugger
			self.subject
		end


		def to_s
			self.subject
		end


	end
end