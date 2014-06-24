class RestMCO < Sinatra::Application
    get "/" do
        RestMCOConfig.logger.debug "Calling Rest BasePage"
        "Welcome to the Mcollective Rest Server"             
    end
end
