Devise::Async.setup do |config|
  config.secret_key = '4dfcacf9d92d1058cf05bccdcab87f88cfe31e58cd7b75c681a6133af48e4235b4cd48c1a866cd040347688b0e33be6e9e82ff5735fc6acd88d62c5c9fc8dc18'
  if Rails.env.test? || Rails.env.development?
    config.enabled = false
  else
    config.enabled = true
  end
  config.backend = :delayed_job
end