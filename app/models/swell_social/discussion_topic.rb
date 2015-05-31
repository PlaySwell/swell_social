module SwellSocial
	class DiscussionTopic < UserPost


		def discussion
			self.parent_obj
		end

		def posts
			DiscussionPost.where( parent_obj_id: self.id, parent_obj_type: self.class.name.demodulize )
		end


	end
end