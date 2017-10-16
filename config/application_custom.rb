module Consul
  class Application < Rails::Application
      config.paths['app/models/concerns'].unshift(Rails.root.join('app', 'models', 'concerns', 'custom'))
  end
end
