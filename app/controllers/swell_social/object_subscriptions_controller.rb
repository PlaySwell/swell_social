
module SwellSocial
	class ObjectSubscriptionsController < ApplicationController

		before_filter :authenticate_user!

		def create
			@sub = ObjectSubscription.where( user_id: current_user.id, parent_obj_type: params[:obj_type], parent_obj_id: params[:obj_id] ).first_or_initialize
			if @sub.active!
				@sub.parent_obj.increment!( :cached_subscribe_count ) if @sub.parent_obj.respond_to?( :cached_subscribe_count )
				record_user_event( 'obj_subscribe', user: current_user, on: @sub.parent_obj, content: "subscribed to the #{@sub.parent_obj.class.name.downcase} <a href='#{@sub.parent_obj.url}'>#{@sub.parent_obj.to_s}</a>!" ) if defined?( SwellPlay )
				set_flash "Subscribed"
			else
				set_flash "Could not subscribe", :error, @sub
			end
			redirect_to :back
		end


		def destroy
			@sub = ObjectSubscription.active.where( user_id: current_user.id ).find_by( id: params[:id] )
			if @sub.deleted!
				@sub.parent_obj.decrement!( :cached_subscribe_count ) if @sub.parent_obj.respond_to?( :cached_subscribe_count )
				set_flash "Unsubscribed"
			else
				set_flash "Could not unsubscribe", :error, @sub
			end
			redirect_to :back
		end

	end

end