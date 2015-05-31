
module SwellSocial
	class Discussion < SwellMedia::Media

		def topics
			DiscussionTopic.where( parent_obj_id: self.id, parent_obj_type: self.class.name.demodulize )
		end

	end
end