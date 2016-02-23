
module SwellSocial

	class UserPost < ActiveRecord::Base
		self.table_name = 'user_posts'
		include SwellMedia::Concerns::TagArrayConcern

		enum status: { 'to_moderate' => -1, 'draft' => 0, 'active' => 1, 'removed' => 2, 'trash' => 3 }
		enum availability: { 'just_me' => 1, 'anyone' => 2 }

		validate 				:check_duplicates
		validates_presence_of 	:content, unless: :allow_blank_content

		attr_accessor	:allow_blank_content


		belongs_to :user, class_name: SwellMedia.registered_user_class
		belongs_to :actor, class_name: SwellMedia.registered_user_class
		belongs_to :parent_obj, polymorphic: true

		has_many 		:replies, class_name: UserPost.name, foreign_key: 'reply_to_id', inverse_of: :reply_to
		belongs_to 	:reply_to, class_name: UserPost.name, inverse_of: :replies

		acts_as_taggable_array_on :tags

		include FriendlyId
		friendly_id :slugger, use: :slugged

		def self.not_reply
			where( reply_to_id: nil )
		end

		def self.reply
			where.not( reply_to_id: nil )
		end

		def reply?
			reply_to_id.present?
		end

		def root_user_post
			if reply?
				reply_to.root_user_post || reply_to
			else
				nil
			end
		end

		def self.within_last( period=1.minute )
			period_ago = Time.zone.now - period
			where( "created_at >= ?", period_ago )
		end

		def self.has_content
			where("((content = '') IS FALSE)")
		end

		def self.no_content
			where.not("((content = '') IS FALSE)")
		end

		def self.order_has_content_desc
			order( "((content = '') IS FALSE) DESC" )
		end

		def self.order_has_content_asc
			order( "((content = '') IS FALSE) ASC" )
		end

		def to_s
			"#{self.user}'s comment on #{self.parent_obj.to_s}"
		end

		def url( args={} )
			self.parent_obj.url( args ) + "##{self.class.name.to_s.demodulize}_#{self.id}"
		end


		private

			def check_duplicates
				if self.persisted? || self.content.blank?
					check_query = UserPost.none
				else
					check_query = UserPost.where( parent_obj_id: self.parent_obj_id, parent_obj_type: self.parent_obj.class.name, user_id: self.user_id, content: self.content ).within_last( 1.minute )
				end

				if check_query.present?
					self.errors.add :content, "Duplicate"
					return false
				end
			end

			def slugger
				self.subject.blank? ? self.id : self.subject
			end

	end

end