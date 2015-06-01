
module SwellSocial
	class DiscussionPostsController < ApplicationController

		def create
			@topic = DiscussionTopic.active.friendly.find( params[:topic_id] )
			@post = @topic.posts.new( user: current_user, content: params[:content] )
			if @post.save
				# TODO throw user_event
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
