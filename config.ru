require ::File.join( ::File.dirname(__FILE__), 'app' )
restmco = RestMCO.new
RestMCOConfig.restmco_log.info "RestMCO Server started @ " + Time.now.to_s
run restmco
#RestMCOConfig.restmco_log.info "RestMCO stopped @ " + Time.now.to_s
