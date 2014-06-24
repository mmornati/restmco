require 'oauth2'

module RestMCOOAuth

    @@oauth_client = nil

    def self.initialize
        @@oauth_client ||= OAuth2::Client.new(RestMCOConfig.get["OAUTH_UNAME"], RestMCOConfig.get["OAUTH_SECRET"], {
            :site => RestMCOConfig.get["OAUTH_SITE"], 
            :authorize_url => RestMCOConfig.get["OAUTH_AUTH_URL"], 
            :token_url => RestMCOConfig.get["OAUTH_TOKEN_URL"]
        })
    end

    def self.get_client
        initialize unless @@oauth_client
        @@oauth_client
    end

end
