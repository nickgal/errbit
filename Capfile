require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/puma'
require 'capistrano/puma/monit'
require 'capistrano/puma/nginx'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
