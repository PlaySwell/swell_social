
module SwellSocial
	class VotesController < ApplicationController
		before_filter :authenticate_user!


		def index
			create
		end

		def create
			@vote = Vote.where( user_id: current_user.id, parent_obj_type: params[:parent_obj_type], parent_obj_id: params[:parent_obj_id], context: params[:context] ).first_or_initialize
			@vote.val = params[:val].try( :to_i ) || params[:up].try( :to_i ) || 1

			if @vote.save
				add_user_event_for( @vote )

				respond_to do |format|
					format.html { redirect_to :back }
					format.js {}
				end
			else
				@error = 'Vote could not be saved'
				set_flash @error, :error, @vote

				respond_to do |format|
					format.html { redirect_to :back }
					format.js {}
				end
			end
		end


		def destroy
			@vote = Vote.find( params[:id] )
			@vote.destroy
			@vote.update_parent_caches

			respond_to do |format|
				format.html { redirect_to :back }
				format.js {}
			end
		end

		def update
			# this action flips the vote!
			@vote = Vote.find( params[:id] )
			if @vote.up?
				dir = 'down'
				@vote.val = dir
			else
				dir = 'up'
				@vote.val = dir
			end

			if @vote.save
				add_user_event_for( @vote )
			end

			respond_to do |format|
				format.html { redirect_to :back }
				format.js {}
			end
		end


		private
			def add_user_event_for( vote )
				if vote.up?
					event = 'upvote'
					if vote.context == 'like'
						verb = 'liked'
					else
						verb = 'up voted'
					end
				else # downvote
					event = 'downvote'
					if vote.context == 'like'
						verb = 'disliked'
					else
						verb = 'down voted'
					end
				end
				user_event = record_user_event( event: event, on: vote.parent_obj, obj: vote, content: "#{verb} <a href='#{vote.parent_obj.url}'>#{vote.parent_obj.to_s}</a>", rate: 10.seconds, update_caches: false )
				vote.update_parent_caches
			end

	end
end