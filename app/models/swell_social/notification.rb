module SwellSocial

	class Notification < ActiveRecord::Base
		self.table_name = 'notifications'

		acts_as_nested_set

		enum status: { 'hidden' => 0, 'unnoticed' => 1, 'unread' => 2, 'read' => 3, 'archived' => 4, 'trash' => 5 }

		belongs_to		:user, class_name: SwellMedia.registered_user_class
		belongs_to		:actor, class_name: SwellMedia.registered_user_class
		belongs_to		:parent_obj, polymorphic: true
		belongs_to		:activity_obj, polymorphic: true

		has_many :actors, through: :children

		def self.active
			where( status: [1,2,3] )
		end

		def self.not_read
			where( status: [1,2] )
		end

		def actor_list
			if children_count > 0
				self.actors.reorder( 'notifications.created_at ASC' )
			else
				SwellMedia.registered_user_class.constantize.where( id: self.actor_id )
			end
		end

		def actor_str( args = {} )

			args[:max_actors] ||= 3

			total_actors = self.actor_list.count

			actor_shortlist = self.actor_list.limit(args[:max_actors])

			actor_shortlist_join_count = [(actor_shortlist.count-2),0].max

			message_actors = actor_shortlist[0..actor_shortlist_join_count].collect{|user| "<a href='#{user.url}'>#{user}</a>" }.join(', ')

			if total_actors > actor_shortlist.count
				message_actors = "#{message_actors} and #{total_actors - actor_shortlist.count} others"
			elsif actor_shortlist.count > 1
				message_actors = "#{message_actors} and <a href='#{actor_shortlist.last.url}'>#{actor_shortlist.last}</a>"
			end

			message_actors

		end

		def sanitized_actor_message
			ActionView::Base.full_sanitizer.sanitize( self.actor_str )
		end

		def sanitized_title
			ActionView::Base.full_sanitizer.sanitize( self.title )
		end

		def to_s
			"#{self.actor_str} #{self.title}"
		end

		def active?
			unnoticed? || unread? || read?
		end

	end

end