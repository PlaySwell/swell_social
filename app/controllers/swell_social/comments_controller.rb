module SwellSocial
	class CommentsController < ApplicationController


		def index

			@direction = (params[:direction] || 'desc').to_sym

			if params[:reply_to_id].present?

				@parent = UserPost.find( params[:reply_to_id] )
				@parent_obj = @parent.parent_obj
				@comments = UserPost.where( reply_to_id: @parent.id ).order(created_at: :asc)
				@direction = :asc

			else
				@parent_obj = params[:parent_obj_type].constantize.find(params[:parent_obj_id])

				@comments = @parent_obj.try(params[:comment_attribute] || :comments)
				@comments ||= UserPost.where( parent_obj_id: @parent_obj.id, parent_obj_type: @parent_obj.class.name )
				@comments = @comments.where( reply_to_id: nil )
			end

			@comments = @comments.active

			@comments = @comments.page( params[:page] ).per( params[:per] || 6 ) if params[:paged]

			@target = params[:target] || ".comments-for.comments-for-#{(@parent || @parent_obj).class.name.underscore.gsub('/','_')}-#{(@parent || @parent_obj).id}"

			if params[:format].to_s == 'js'

				if params[:layout] == '0'
					render 'swell_social/comments/index.js', layout: false

				else
					render 'swell_social/comments/index.js'
				end

			else

				if params[:layout] == '0'
					render 'swell_social/comments/index', layout: false

				else
					render 'swell_social/comments/index'
				end

			end

		end

	end
end