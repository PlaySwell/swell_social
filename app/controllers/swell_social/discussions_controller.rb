module SwellSocial
	class DiscussionsController < ApplicationController

		def index
			@discussions = Discussion.published	
		end

		def show
			@discussion = Discussion.published.friendly.find( params[:id] )
		end

	end
end