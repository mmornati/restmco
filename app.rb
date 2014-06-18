# encoding: utf-8
require 'sinatra'
#require 'haml'

require_relative 'helpers/init'
class RestMCO < Sinatra::Application
    include RestMCOConfig
	enable :sessions

	configure :production do
	end

	configure :development do

	end

end

#require_relative 'helpers/init'
require_relative 'routes/init'
