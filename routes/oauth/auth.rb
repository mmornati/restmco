class RestMCO < Sinatra::Application

    SCOPES = [
            'https://www.googleapis.com/auth/userinfo.email'
    ].join(' ')

    get "/auth" do
        redirect RestMCOOAuth.get_client.auth_code.authorize_url(:redirect_uri => redirect_uri,:scope => SCOPES,:access_type => "offline")
    end
     
    get '/oauth2callback' do
      access_token = RestMCOOAuth.get_client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
      session[:access_token] = access_token.token
      @message = "Successfully authenticated with the server"
      @access_token = session[:access_token]
     
      # parsed is a handy method on an OAuth2::Response object that will 
      # intelligently try and parse the response.body
      @email = access_token.get('https://www.googleapis.com/userinfo/email?alt=json').parsed
      erb :success
    end
     
    def redirect_uri
      uri = URI.parse(request.url)
      uri.path = '/oauth2callback'
      uri.query = nil
      uri.to_s
    end

end
