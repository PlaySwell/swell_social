module SwellSocial
	class UserPostsController < ApplicationController
		
		before_filter 	:authenticate_user!
		before_filter   :get_parent_obj, only: :create

		
		def admin
			authorize!( :admin, Comment )
			@posts = UserPost.order( created_at: :desc )
			render layout: 'admin'
		end


		def create
			@post = UserPost.new( type: params[:comment_type], parent_obj_id: @parent_obj.id, parent_obj_type: @parent_obj.class.name, user: current_user, subject: params[:subject], content: params[:content], status: ( params[:draft] ? 'draft' : 'active' ) )
			@list = List.active.friendly.find( @parent_obj.id )
			
			respond_to do |format|
				if @post.save
					if @reply_to_comment = UserPost.find_by( id: params[:reply_to_id] )
						@post.move_to_child_of( @reply_to_comment )
					end
					
					# throw site event
					record_user_event( 'comment', on: @parent_obj, content: "commented on the #{@post.parent_obj.class.name.downcase} <a href='#{@post.parent_obj.url}'>#{@post.parent_obj.title}</a>!" )
					format.html { redirect_to(:back, set_flash: 'Thanks for your comment') }
					format.js {}
				else
					format.html { redirect_to(:back, set_flash: 'Comment could not be saved') }
					format.js {}
				end
			end

			# redirect_to :back
		end

		def destroy
			authorize!( :admin, UserPost )
			@post = UserPost.find( params[:id] )
			@post.update( status: 'deleted' )
			set_flash 'Comment Deleted'
			redirect_to :back
		end

		def edit
			authorize!( :admin, UserPost )
			@post = UserPost.find( params[:id] )
			render layout: 'admin'
		end

		def update
			@post = UserPost.find( params[:id] )
			authorize( @post, :admin_update? )
			if @post.update( comment_params )
				set_flash "Comment Updated"
			else
				set_flash "Comment could not be updated", :error, @post
			end
			redirect_to :back
		end


		private

			def comment_params
				params.require( :user_post ).permit( :title, :subject, :user_id, :content, :status )
			end

			def get_parent_obj
				if params[:type].present?
					@parent_obj = params[:type].constantize.where( id: params[:id] ).first 
				else
					set_flash 'Can not comment without parent', :error
					redirect_to :back
					return false
				end
			end

	end
end