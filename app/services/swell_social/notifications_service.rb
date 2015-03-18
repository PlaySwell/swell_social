
module SwellSocial

	class NotificationService

		def self.notify( recipients, actor, message, event, args = {} )
			# @todo insert more efficiently
			# @todo start a job to process event notifications... they don't need to be synchronous
			# @todo run a cron which batches events together into a notification (Mac Knife and 3 other products have dropped in price)



		recipients.each do | recipient |

				user = recipient
				user = recipient.user if recipient.is_a? ObjectSubscription

				Notification.create user: user, actor: actor, content: message, status: args[:status] || 'unread', user_event: event
				# @coulddo push notifications
				# @todo count updates

			end

		end

	end

end