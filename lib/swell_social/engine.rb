
require 'awesome_nested_set'
require 'swell_social/models/concerns/notify_concern'
require 'swell_social/models/concerns/trigger_notification_concern'

module SwellSocial
	class Engine < ::Rails::Engine
		isolate_namespace SwellSocial

		ActiveRecord::Base.send :include, SwellSocial::Concerns::NotifyConcern

		initializer "swell_social.load_helpers" do |app|
			SwellMedia::UserEvent.send :include, SwellSocial::Concerns::TriggerNotificationConcern
		end

		config.generators do |g|
			g.test_framework :rspec
			g.fixture_replacement :factory_girl, :dir => 'spec/factories'
		end
		
	end
end
