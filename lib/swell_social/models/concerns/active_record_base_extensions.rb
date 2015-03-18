module SwellSocial
	module Concerns

		module ActiveRecordBaseExtensions
			extend ActiveSupport::Concern

			included do
				#scope :disabled, -> { where(disabled: true) }
				#after_create {
				#	if self.class.notify_attributes[:create].present?
				#
				#		content = self.class.notify_attributes[:create][:content]
				#		content = self.try( content ) if content.is_a? Symbol
				#
				#		title = self.class.notify_attributes[:create][:title]
				#		title = self.try( title ) if title.is_a? Symbol
				#
				#		actor = self.try( self.class.notify_attributes[:create][:actor] ) if self.class.notify_attributes[:create][:title].present?
				#
				#		self.send_notification( content, { title: title, actor: actor } )
				#
				#	end
				#}
			end


			####################################################
			# Class Methods

			module ClassMethods

				@notify_attributes = {}
				@notify_method = nil

				def notify_attributes
					@notify_attributes
				end
				def notify_method
					@notify_method
				end

				def notify( method, args = {} )
					@notify_attributes = args
					@notify_method = method

					true
				end

			end

			def send_notification( content, args = {} )

				if self.class.notify_method.present?

					notify_attributes = self.notify_attributes

					event = args.delete(:event)

					recipients = notify_attributes[:recipients]

					if recipients.present? && ( notify_attributes[:on].nil? || event.nil? || notify_attributes[:on] == event || notify_attributes[:on].include?( event ) )

						#args.merge!( regarding_obj: self )

						NotificationService.notify( recipients, content, args )

					end

					true

				else

					false

				end

			end



			def notify_attributes
				if self.class.notify_method

					recipients = self.try( self.class.notify_method )

					if recipients.nil?
						recipients = nil
					elsif recipients.is_a? ActiveRecord::Base
						recipients = [ recipients ]
					end

					self.class.notify_attributes.merge( recipients: recipients )

				else
					nil
				end
			end

		end

	end
end