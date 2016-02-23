module SwellSocial
	class CommentsController < ApplicationController


		def index

			if params[:reply_to_id].present?
				@parent = UserPost.find( params[:reply_to_id] )
				@parent_obj = @parent.parent_obj
			else
				@parent_obj = params[:parent_obj_type].constantize.find(params[:parent_obj_id])
			end

			@comments = @parent_obj.try(params[:comment_attribute] || :comments)
			@comments ||= UserPost.where( parent_obj_id: @parent_obj.id, parent_obj_type: @parent_obj.class.name )
			@comments = @comments.where( reply_to_id: @parent.id ) if @parent.present?

			@comments = @comments.page( params[:page] ).per( params[:per] || 6 ) if params[:paged]

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