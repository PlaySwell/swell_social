
require 'awesome_nested_set'

module SwellSocial
	class Engine < ::Rails::Engine
		isolate_namespace SwellSocial
	
		config.generators do |g|
			g.test_framework :rspec
			g.fixture_replacement :factory_girl, :dir => 'spec/factories'
		end
		
	end
end
