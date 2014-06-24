require 'mcollective'
class RestMCO < Sinatra::Application

    post '/scheduler/status/:jobid/' do
        content_type :json
        RestMCOConfig.logger.debug "Calling /schedstatus url"
        jobreq = { :jobid => params[:jobid] }
        begin
            sched = MCollective::RPC::Client.new("scheduler", 
                :configfile => MCO_CONFIG, 
                :options => {
                        :verbose      => false,
                        :progress_bar => false,
                        :timeout      => RestMCOConfig.get_mco_config["MCO_TIMEOUT"],
                        :config       => RestMCOConfig.get_mco_config["MCO_CONFIG"],
                        :filter       => MCollective::Util.empty_filter,
                        :collective   => RestMCOConfig.get_mco_config["MCO_COLLECTIVE"],
                })
        rescue Exception => e
            RestMCOConfig.logger.error e.message
        end
        if sched.nil?
            return JSON.dump([{"sender"=>"ERROR","statuscode"=>1,"statusmsg"=>"ERROR","data"=>{"message"=>e.message}}])
        end
        body_content = request.body.read
        data = (body_content.nil? or body_content.empty?) ? {} : recursive_symbolize_keys(JSON.parse(body_content))
        Utils.set_filters(sched, data)
        json_response = JSON.dump(sched.query(jobreq).map{|r| r.results})
        RestMCOConfig.logger.info "Command schedstatus #{params[:jobid]} executed on filters #{JSON.dump(data[:filters])}"
        RestMCOConfig.logger.debug "Response received: #{json_response}"
        json_response
    end
    
    post '/scheduler/output/:jobid/' do   
        content_type :json
        RestMCOConfig.logger.debug "Calling /schedoutput url"
        jobreq = { :jobid => params[:jobid], :output => 'yes' }
        begin
            sched = MCollective::RPC::Client.new("scheduler", 
                    :configfile => MCO_CONFIG, 
                    :options => {
                        :verbose      => false,
                        :progress_bar => false,
                        :timeout      => RestMCOConfig.get_mco_config["MCO_TIMEOUT"],
                        :config       => RestMCOConfig.get_mco_config["MCO_CONFIG"],
                        :filter       => MCollective::Util.empty_filter,
                        :collective   => RestMCOConfig.get_mco_config["MCO_COLLECTIVE"],
                    } )
        rescue Exception => e
            RestMCOConfig.logger.error e.message
        end
        if sched.nil?
            return JSON.dump([{"sender"=>"ERROR","statuscode"=>1,"statusmsg"=>"ERROR","data"=>{"message"=>e.message}}])
        end
        body_content = request.body.read
        data = (body_content.nil? or body_content.empty?) ? {} : recursive_symbolize_keys(JSON.parse(body_content))
        Utils.set_filters(sched, data)
        json_response = JSON.dump(sched.query(jobreq).map{|r| r.results})
        RestMCOConfig.logger.info "Command scheoutput #{params[:jobid]} executed on filters: #{JSON.dump(data[:filters])}"
        RestMCOConfig.logger.debug "Response received: #{json_response}"
        json_response
    end
    
    post '/scheduler/mco/:agent/:action/' do
        content_type :json
        RestMCOConfig.logger.debug "Calling /mcollective url Agent: #{params[:agent]} Action:#{params[:action]}"
        body_content = request.body.read
        data = (body_content.nil? or body_content.empty?) ? {} : JSON.parse(body_content)
        data.recursive_symbolize_keys!
        RestMCOConfig.logger.debug "JSON Data: #{JSON.dump(data)}"
        RestMCOConfig.logger.info "Executing with backend scheduler"
        scheduler_data=data[:schedule]
        scheduler_data[:schedtype] ||='in'
        scheduler_data[:schedarg]  ||='0s'
        jobreq = { :agentname  => params[:agent],
                   :actionname => params[:action],
                   :schedtype  => scheduler_data[:schedtype],
                   :schedarg   => scheduler_data[:schedarg] }
        begin
            sched = MCollective::RPC::Client.new("scheduler", 
                    :configfile => MCO_CONFIG, 
                    :options => {
                        :verbose      => false,
                        :progress_bar => false,
                        :timeout      => RestMCOConfig.get_mco_config["MCO_TIMEOUT"],
                        :config       => RestMCOConfig.get_mco_config["MCO_CONFIG"],
                        :filter       => MCollective::Util.empty_filter,
                        :collective   => RestMCOConfig.get_mco_config["MCO_COLLECTIVE"],
                    } )
        rescue Exception => e
            RestMCOConfig.logger.error e.message
        end
        if sched.nil?
            return JSON.dump([{"sender"=>"ERROR","statuscode"=>1,"statusmsg"=>"ERROR","data"=>{"message"=>e.message}}])
        end

        Utils.set_filters(sched, data)
        unless data[:parameters].nil? or data[:parameters].empty?
            jobreq[:params] = data[:parameters].keys.join(",")
            jobreq.merge!(data[:parameters])
        end
        json_response = JSON.dump(sched.schedule(jobreq).map{|r| r.results})
        RestMCOConfig.logger.info "Command Agent: #{params[:agent]} Action: #{params[:action]} executed"
        RestMCOConfig.logger.debug "Response received: #{json_response}"
        json_response
    end
end
