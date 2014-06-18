class RestMCO < Sinatra::Application
    get "/" do
        RestMCOConfig.restmco_log.debug "Calling Rest BasePage"
        "Welcome to the Mcollective Rest Server"             
    end
end
