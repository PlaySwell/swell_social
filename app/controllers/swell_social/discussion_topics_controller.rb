
module SwellSocial
	class DiscussionTopicsController < ApplicationController


		def create
			@discussion = Discussion.published.friendly.find( params[:discussion_id] )
			@topic = @discussion.topics.new( user: current_user, subject: params[:subject], content: params[:content] )
			if @topic.save
				# TODO throw user_event
				set_flash "Topic Posted"
			else
				set_flash "Couldn't create Topic", :danger, @topic
			end
			redirect_to :back
		end

		def show
			@discussion = Discussion.published.friendly.find( params[:discussion_id] )
			@topic = @discussion.topics.find( params[:id] )
			@posts = @topic.posts.active.order( created_at: :desc ).page( params[:page] )
			record_user_event( :impression, on: @topic, content: "viewed #{@topic}" )
		end

	end

end