
module SwellSocial
	class ObjectSubscriptionsController < ApplicationController

		before_filter :authenticate_user!

		def create
			@sub = ObjectSubscription.where( user_id: current_user.id, parent_obj_type: params[:obj_type], parent_obj_id: params[:obj_id] ).first_or_initialize
			@button_class = params[:button_class]
			
			respond_to do |format|
			  if @sub.active!
				@sub.parent_obj.increment!( :cached_subscribe_count ) if @sub.parent_obj.respond_to?( :cached_subscribe_count )
				record_user_event( "#{@sub.parent_obj.class.name.demodulize.underscore}_subscribe", user: current_user, on: @sub.parent_obj, content: "subscribed to the #{@sub.parent_obj.class.name.downcase} <a href='#{@sub.parent_obj.url}'>#{@sub.parent_obj.to_s}</a>!" )
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
					@sub.parent_obj.decrement!( :cached_subscribe_count ) if @sub.parent_obj.respond_to?( :cached_subscribe_count )
					record_user_event( "#{@sub.parent_obj.class.name.demodulize.underscore}_unsubscribe", user: current_user, on: @sub.parent_obj, content: "unsubscribed from the #{@sub.parent_obj.class.name.downcase} <a href='#{@sub.parent_obj.url}'>#{@sub.parent_obj.to_s}</a>!" )
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