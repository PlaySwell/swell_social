
module SwellSocial

	class UserPost < ActiveRecord::Base
		self.table_name = 'user_posts'

		enum status: { 'active' => 0, 'to_moderate' => 1, 'removed' => 2, 'trash' => 3 }

		validate :check_duplicates
		validates_presence_of 	:content

		belongs_to :user
		belongs_to :parent_obj, polymorphic: true

		acts_as_nested_set


		def self.within_last( period=1.minute )
			period_ago = Time.zone.now - period
			where( "created_at >= ?", period_ago )
		end



		def to_s
			"#{self.user}'s comment on #{self.parent_obj.to_s}"
		end

		def url
			self.parent_obj.url
		end


		private

			def check_duplicates
				if UserPost.where( user_id: self.user_id, content: self.content ).within_last( 1.minute ).present?
					self.errors.add :content, "Duplicate"
					return false
				end
			end
	end

end