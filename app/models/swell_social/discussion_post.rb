module SwellSocial
	class DiscussionPost < UserPost
		
		def discussion
			self.topic.discussion
		end

		def paginated_page( dir='asc', per_page=25 ) # todo -- finish implementing reverse
			priors = self.topic.posts.active.where( "created_at < :my_created_at", my_created_at: self.created_at ).count
			page = ( priors / per_page ) + 1
		end

		def topic
			DiscussionTopic.find_by( id: self.parent_obj_id )
		end

	end
end
