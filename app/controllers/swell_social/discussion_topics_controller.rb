
module SwellSocial
	class DiscussionTopicsController < ApplicationController


		def create
			
		end

		
		def index
			@topics = DiscussionTopic.published
		end

	end

end