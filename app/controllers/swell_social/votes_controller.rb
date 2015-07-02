
module SwellSocial
	class VotesController < ApplicationController
		before_filter :authenticate_user!

		# def index
		# 	if params['_method'] && params['_method'].upcase == 'POST'
		# 		create()
		# 	else
		# 		raise ActionController::RoutingError.new( 'Not Found' )
		# 	end
		# end

		def create
			@vote = Vote.where( user_id: current_user.id, parent_obj_type: params[:parent_obj_type], parent_obj_id: params[:parent_obj_id], context: params[:context] ).first_or_initialize
			@vote.val = params[:val].try( :to_i ) || params[:up].try( :to_i ) || 1

			if @vote.save
				@vote.update_parent_caches
				#add_user_event_for( @vote )
				redirect_to :back
			else
				set_flash 'Vote could not be saved', :error, vote
				redirect_to :back
				return false
			end
		end

		# def show
		# 	if params['_method'] && params['_method'].upcase == 'DELETE'
		# 		destroy()
		# 	else
		# 		raise ActionController::RoutingError.new( 'Not Found' )
		# 	end
		# end

		def destroy
			@vote = Vote.find( params[:id] )
			@vote.destroy
			@vote.update_parent_caches
			redirect_to :back
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
				#add_site_event_for( @vote )
				@vote.update_parent_caches( dir: dir )
			end
			redirect_to :back
		end


		private
			def add_user_event_for( vote )
				if vote.up?
					if vote.context == 'like'
						user_event = record_user_event( 'upvote', on: vote.parent_obj, content: "liked <a href='#{vote.parent_obj.url}'>#{vote.parent_obj.to_s}</a>", rate: 1.second )
					else
						user_event = record_user_event( 'upvote', on: vote.parent_obj, content: "up voted <a href='#{vote.parent_obj.url}'>#{vote.parent_obj.to_s}</a>", rate: 1.second )
					end
				else # downvote
					if vote.context == 'like'
						user_event = record_user_event( 'downvote', on: vote.parent_obj, content: "disliked <a href='#{vote.parent_obj.url}'>#{vote.parent_obj.to_s}</a>", rate: 1.second )
					else
						user_event = record_user_event( 'downvote', on: vote.parent_obj, content: "down voted <a href='#{vote.parent_obj.url}'>#{vote.parent_obj.to_s}</a>", rate: 1.second )
					end
				end
			end

	end
end