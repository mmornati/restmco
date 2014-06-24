require_relative '../loadini' if RUBY_VERSION >= "1.9"
require File.join(File.dirname(__FILE__), '../loadini') if RUBY_VERSION < "1.9"


module OAuthConfig
  @config = {}

  def self.initialize
      @@oauth_config = {
            'OAUTH_UNAME'      => RestMCOConfig.get_config['oauth']['USERNAME'], 
            'OAUTH_SECRET'     => RestMCOConfig.get_config['oauth']['SECRET'], 
            'OAUTH_SITE' => RestMCOConfig.get_config['oauth']['SITE'], 
            'OAUTH_AUTH_URL'       => RestMCOConfig.get_config['oauth']['AUTH_URL'], 
            'OAUTH_TOKEN_URL'  => RestMCOConfig.get_config['oauth']['TOEK_URL'], 
        }

  end  

  def self.extract 
      @@oauth_config
  end  
end  

$global_procs << { 'module' => 'OAuthConfig',
  'initialize' => 'OAuthConfig.initialize',
  'extract' => 'OAuthConfig.extract' }

