SwellSocial::Engine.routes.draw do
	
	post '/comment_on/:type/:id' => 'user_posts#create', as: 'comment_on'

	resources :discussion_topics, path: :discussions

	resources :object_subscriptions

	resources :user_posts do 
		get :admin, on: :collection
	end

	resources :votes

end
