module SwellSocial
	module Concerns

		module UserEventExtensions
			extend ActiveSupport::Concern

			included do
				after_create :trigger_notifications
			end


			####################################################
			# Class Methods

			module ClassMethods


			end


			def trigger_notifications

				begin

					if parent_obj.present? && parent_obj.respond_to?( :notify_attributes )

						notify_attributes = self.parent_obj.notify_attributes

						if notify_attributes[:recipients].present? && ( notify_attributes[:on].nil? || notify_attributes[:on] == self.name.to_sym || notify_attributes[:on].include?( self.name.to_sym ) )

							NotificationService.notify( notify_attributes[:recipients], self.user, self.content, self )

						end

					end

				rescue => e
					logger.error 'UserEvent#trigger_notifications', e
				end

			end

		end

	end
end