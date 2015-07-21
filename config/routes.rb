SwellSocial::Engine.routes.draw do
	
	post '/comment_on/:type/:id' => 'user_posts#create', as: 'comment_on'

	resources :discussions do 
		resources :topics, controller: :discussion_topics
	end
	resources :discussion_posts
	resources :discussion_admin

	resources :notifications
	
	resources :object_subscriptions

	resources :user_posts do 
		get :admin, on: :collection
	end

	resources :votes, only: [:create, :destroy, :update]

end
