module SwellSocial
	class DiscussionPost < UserPost
		
		def topic
			self.parent_obj
		end
		
	end
end
