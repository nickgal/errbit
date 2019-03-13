if defined? Rack::Attack
  # class Rack::Attack
  #   # your custom configuration...
  # end

  Rack::Attack.safelist('uptime robot') do |req|
    req.user_agent =~ /UptimeRobot/
  end

  Rack::Attack.safelist('permitted ips') do |req|
    # Requests are allowed if the return value is truthy
    ENV.fetch('RACK_ATTACK_SAFELIST_IPS', '').split(',').include?(req.ip)
  end

  Rack::Attack.blocklist('api only') do |req|
    # block everything except posts to the api endpoint
    if req.post? && (req.path =~ /^\/api\/v3\/projects\// || req.path =~ /^\/notifier_api\/v2\/notices\//)
      false # don't block
    else
      true # block
    end
  end

  # throttle to 5rps
  Rack::Attack.throttle('req/ip', limit: 5, period: 1) { |req| req.ip }
end
