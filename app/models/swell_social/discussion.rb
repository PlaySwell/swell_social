
module SwellSocial
	class Discussion < SwellMedia::Media

		def posts
			DiscussionPost.where( parent_obj_id: self.topics.pluck( :id ), parent_obj_type: 'DiscussionTopic' )
		end
		
		def last_post
			if self.posts.active.present?
				self.posts.active.order( created_at: :desc ).first
			else
				self.topics.active.order( created_at: :desc ).first
			end
		end

		def topics
			DiscussionTopic.where( parent_obj_id: self.id, parent_obj_type: self.class.name.demodulize )
		end

		def total_posts_count
			self.topics.count + self.posts.count
		end

	end
end