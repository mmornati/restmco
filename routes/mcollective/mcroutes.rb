require 'mcollective'
class RestMCO < Sinatra::Application
    
    post '/mcollective/:agent/:action/' do
        content_type :json
        RestMCOConfig.restmco_log.debug "Calling /mcollective url Agent: #{params[:agent]} Action:#{params[:action]}"
        body_content = request.body.read
        data = (body_content.nil? or body_content.empty?) ? {} : JSON.parse(body_content)
        data.recursive_symbolize_keys!
        RestMCOConfig.restmco_log.debug "JSON Data: #{JSON.dump(data)}"
        begin
            mc = MCollective::RPC::Client.new(params[:agent], 
                :configfile => RestMCOConfig.get_mco_config["MCO_CONFIG"], 
                :options => {
                    :verbose      => false,
                    :progress_bar => false,
                    :timeout      => RestMCOConfig.get_mco_config["MCO_TIMEOUT"],
                    :config       => RestMCOConfig.get_mco_config["MCO_CONFIG"],
                    :filter       => MCollective::Util.empty_filter,
                    :collective   => RestMCOConfig.get_mco_config["MCO_COLLECTIVE"],
                })
        rescue Exception => e
            RestMCOConfig.restmco_log.error e.message
        end
        if mc.nil?
            return JSON.dump([{"sender"=>"ERROR","statuscode"=>1,"statusmsg"=>"ERROR","data"=>{"message"=>e.message}}])
        end
        mc.discover
        Utils.set_filters(mc, data)
        Utils.set_timeout(mc, data)
        if data[:parameters]
            data[:parameters].each  { |name,value| puts "#{name}: #{value}" }
        end
        if data[:limit]
            limits = data[:limit]
            if limits[:targets]
                mc.limit_targets = "#{limits[:targets]}"
            end
            if limits[:method]
                mc.limit_method = "#{limits[:method]}"
            end
        end
    
        json_response = JSON.dump(mc.send(params[:action], data[:parameters]).map{|r| r.results})
        RestMCOConfig.restmco_log.info "Command Agent: #{params[:agent]} Action: #{params[:action]} executed"
        RestMCOConfig.restmco_log.debug "Response received: #{json_response}"
        json_response
    end
end
