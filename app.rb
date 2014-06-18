# encoding: utf-8
require 'sinatra'

require_relative 'helpers/init'
class RestMCO < Sinatra::Application
    include RestMCOConfig
	enable :sessions

	configure :production do
        RestMCOConfig.load_config('/etc/restmco/restmco.cfg')
        RestMCOConfig.initialize_log
        RestMCOConfig.restmco_log.info "Running RestMCO using production mode"
	end

	configure :development do
        config_file_name = ::File.join( ::File.dirname(__FILE__), 'misc/sysconfig/restmco.cfg' )
        RestMCOConfig.load_config(config_file_name)
        RestMCOConfig.initialize_log
        RestMCOConfig.restmco_log.info "Running RestMCO using development mode"
	end

end

require_relative 'routes/init'
