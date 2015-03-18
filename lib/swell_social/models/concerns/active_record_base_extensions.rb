module SwellSocial
	module Concerns

		module ActiveRecordBaseExtensions
			extend ActiveSupport::Concern

			included do
				#scope :disabled, -> { where(disabled: true) }
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