
module SwellSocial
	class ObjectSubscriptionsController < ApplicationController

		before_filter :authenticate_user!

		def create
			@sub = ObjectSubscription.where( user_id: current_user.id, parent_obj_type: params[:obj_type], parent_obj_id: params[:obj_id] ).first_or_initialize
			@button_class = params[:button_class]
			
			respond_to do |format|
			  if @sub.active!
				record_user_event( event: "subscribe", on: @sub.parent_obj, content: "subscribed to the #{@sub.parent_obj.class.name.downcase} <a href='#{@sub.parent_obj.try(:url)}'>#{@sub.parent_obj.to_s}</a>!" )
				format.html { redirect_to(:back, set_flash: 'Subscribed') }
				format.js {}
			  else
				format.html { redirect_to(:back, set_flash: 'Error') }
				format.js {}
			  end
			end

		end


		def destroy
			@sub = ObjectSubscription.active.where( user_id: current_user.id ).find_by( id: params[:id] )
			@button_class = params[:button_class]

			respond_to do |format|
				if @sub.deleted!
					record_user_event( event: "unsubscribe", user: current_user, on: @sub.parent_obj, content: "unsubscribed from the #{@sub.parent_obj.class.name.downcase} <a href='#{@sub.parent_obj.try(:url)}'>#{@sub.parent_obj.to_s}</a>!" )
					format.html { redirect_to(:back, set_flash: 'Unsubscribed') }
					format.js {}
				else
					format.html { redirect_to(:back, set_flash: 'Could not unsubscribe') }
					format.js {}
				end
			end

		end

	end

end