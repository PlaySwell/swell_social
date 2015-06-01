module SwellSocial
	class DiscussionsController < ApplicationController

		def index
			@discussions = Discussion.published	
		end

		def show
			@discussion = Discussion.published.friendly.find( params[:id] )
			@topics = @discussion.topics.active.order( created_at: :desc ).page( params[:page] )
			# TODO throw user event
		end

	end
end