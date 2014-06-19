# encoding: utf-8
require 'sinatra'
require 'rubygems' if RUBY_VERSION < "1.9"

require_relative 'helpers/init'

class RestMCO < Sinatra::Application
    include RestMCOConfig
	enable :sessions
    set :session_secret, 'Zp2FzDj4R234sCS2TuX89zsBkU6rc86n'

	configure :production do
        RestMCOConfig.load_config('/etc/restmco/restmco.cfg')
        RestMCOConfig.initialize_all
        RestMCOConfig.restmco_log.info "Running RestMCO using production mode"
	end

	configure :development do
        config_file_name = ::File.join( ::File.dirname(__FILE__), 'misc/sysconfig/restmco.cfg' )
        RestMCOConfig.load_config(config_file_name)
        RestMCOConfig.initialize_all
        RestMCOConfig.restmco_log.info "Running RestMCO using development mode"
	end

end

require_relative 'routes/init'
