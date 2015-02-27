class SwellSocialMigration < ActiveRecord::Migration
	def change

		enable_extension 'hstore'

		
		create_table :object_subscriptions do |t|
			t.references		:user
			t.references		:parent_obj, 			polymorphic: true
			t.references		:category
			t.string			:format,				default: 'site' 	# email
			t.integer			:status, 				default: 1
			t.integer			:availability, 			default: 1 	# just_me, anyone for add-to-profile
			t.hstore			:properties
			t.timestamps
		end
		add_index :object_subscriptions, :user_id
		add_index :object_subscriptions, [ :parent_obj_id, :parent_obj_type ]


		# base for comments
		create_table :user_posts do |t|
			t.references		:user
			t.references		:parent_obj,			polymorphic: true
			t.references		:parent 				# for nested_set 
			t.integer			:lft
			t.integer			:rgt
			t.string			:type
			t.string 			:slug
			
			t.string			:subject
			t.text				:content

			t.integer			:cached_vote_count,				default: 0, 	limit: 8
			t.float				:cached_vote_score,				default: 0, 	limit: 8
			t.integer			:cached_upvote_count,			default: 0, 	limit: 8
			t.integer			:cached_downvote_count,			default: 0, 	limit: 8
			t.integer			:cached_subscribe_count, 		default: 0

			t.float				:computed_score,				default: 0
			t.integer			:status, 						default: 1
			t.integer			:availability, 					default: 1 	# anyone, logged_in, just_me
			t.datetime 			:modified_at
			t.hstore			:properties
			t.timestamps
		end
		add_index :user_posts, :user_id
		add_index :user_posts, [ :parent_obj_id, :parent_obj_type ]
		add_index :user_posts, :parent_id


		create_table :votes do |t|
			t.references 		:parent_obj, polymorphic: true
			t.references 		:user
			t.references 		:site
			t.integer 			:val, 			default: 0  # enum -1 down, 1 up
			t.string 			:context,		default: 'vote'
			t.text 				:content # in case of comment
			t.hstore			:properties
			t.timestamps
		end
		add_index :votes, :user_id
		add_index :votes, [ :parent_obj_id, :parent_obj_type ]
		add_index :votes, [ :parent_obj_id, :parent_obj_type, :context ]
		add_index :votes, [ :user_id, :context ]


	end
end