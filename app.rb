# encoding: utf-8
require 'sinatra'
require 'rubygems' if RUBY_VERSION < "1.9"

require_relative 'helpers/init' if RUBY_VERSION >= "1.9"
require File.join(File.dirname(__FILE__), 'helpers/init') if RUBY_VERSION < "1.9"
require_relative 'configs/init' if RUBY_VERSION >= "1.9"
require File.join(File.dirname(__FILE__), 'configs/init') if RUBY_VERSION < "1.9"

class RestMCO < Sinatra::Application
    include RestMCOConfig
	enable :sessions
    set :session_secret, 'Zp2FzDj4R234sCS2TuX89zsBkU6rc86n'

	configure :production do
        RestMCOConfig.load_config('/etc/mcollective-restapi/mcollective-restapi.cfg')
        RestMCOConfig.initialize_all
        RestMCOConfig.logger.info "Running RestMCO using production mode"
        RestMCOConfig.logger.debug "#{RestMCOConfig.get}"
	end

	configure :development do
        config_file_name = ::File.join( ::File.dirname(__FILE__), 'misc/sysconfig/mcollective-restapi.cfg' )
        RestMCOConfig.load_config(config_file_name)
        RestMCOConfig.initialize_all
        RestMCOConfig.logger.info "Running RestMCO using development mode"
        RestMCOConfig.logger.debug "Configuration"
        RestMCOConfig.logger.debug "#{RestMCOConfig.get}"
	end

end

require_relative 'routes/init' if RUBY_VERSION >= "1.9"
require File.join(File.dirname(__FILE__), 'routes/init') if RUBY_VERSION < "1.9"
