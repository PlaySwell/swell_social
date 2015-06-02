
module SwellSocial
	class DiscussionTopicsController < ApplicationController

		before_filter :authenticate_user!

		def create
			@discussion = Discussion.published.friendly.find( params[:discussion_id] )
			@topic = DiscussionTopic.new( user: current_user, parent_obj_id: @discussion.id, parent_obj_type: @discussion.class.name, subject: params[:subject], content: params[:content] )
			if @topic.save
				record_user_event( :discussion_topic, on: @topic, content: "posted the topic: #{@topic.preview} in the discussion: #{@discussion.title}." )
				set_flash "Topic Posted"
			else
				set_flash "Couldn't create Topic", :danger, @topic
			end
			redirect_to :back
		end

		def show
			@discussion = Discussion.published.friendly.find( params[:discussion_id] )
			@topic = @discussion.topics.friendly.find( params[:id] )
			@posts = @topic.posts.active.order( created_at: :asc ).page( params[:page] )
			record_user_event( :impression, on: @topic, content: "viewed #{@topic}" )
		end

	end

end