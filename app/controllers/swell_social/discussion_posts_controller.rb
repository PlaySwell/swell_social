
module SwellSocial
	class DiscussionPostsController < ApplicationController

		before_filter :authenticate_user!

		def create
			@topic = DiscussionTopic.active.friendly.find( params[:topic_id] )
			@post = DiscussionPost.new( user: current_user, parent_obj_id: @topic.id, parent_obj_type: @topic.class.name, content: params[:content] )
			if @post.save
				record_user_event( :discussion_post, on: @post, content: "replied to the topic: #{@topic.preview}." )
				set_flash "Posted"
			else
				set_flash "Couldn't create Post", :danger, @post
			end
			redirect_to :back
		end

		def edit
			
		end

		def update
			
		end
		
	end
end
