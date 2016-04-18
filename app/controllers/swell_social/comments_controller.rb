module SwellSocial
	class CommentsController < ApplicationController


		def index

			@parent_obj = params[:parent_obj_type].constantize.find(params[:parent_obj_id])

			@target = params[:target] #todo filter bad characters

			if params[:format].to_s == 'js'

				render 'swell_social/comments/index.js', layout: false

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