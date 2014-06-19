module Utils

    def self.recursive_symbolize_keys! hash
        hash.symbolize_keys!
        hash.values.select{|v| v.is_a? Hash}.each{|h| recursive_symbolize_keys!(h)}
    end
    
    def self.set_filters(mc, params)
        if params[:filters] then
            params[:filters].each do |filter_type, filter_values|
                RestMCOConfig.restmco_log.debug "#{filter_type}: #{filter_values.class == Array ? JSON.dump(filter_values) : filter_values}"
                case filter_type
                when :class
                    RestMCOConfig.restmco_log.debug "Applying class_filter"
                    filter_values.each do |value|
                        mc.class_filter "/#{value}/"
                    end
                when :fact
                    RestMCOConfig.restmco_log.debug "Applying fact_filter"
                    filter_values.each do |value|
                        mc.fact_filter "#{value}"
                    end
                when :agent
                    RestMCOConfig.restmco_log.debug "Applying agent_filter"
                    filter_values.each do |value|
                        mc.agent_filter "#{value}"
                    end
                when :identity
                    RestMCOConfig.restmco_log.debug "Applying identity_filter"
                    filter_values.each do |value|
                        mc.identity_filter "#{value}"
                    end
                when :compound
                    RestMCOConfig.restmco_log.debug "Applying compound_filter"
                    RestMCOConfig.restmco_log.debug "compound : #{filter_values}"
                    mc.compound_filter "#{filter_values}"
                end
            end
        end
    end
    
    def self.set_timeout(mc, params)
        if params[:timeout] then
           RestMCOConfig.restmco_log.debug "Applying timeout"
           RestMCOConfig.restmco_log.debug "timeout : #{params[:timeout]}"
           mc.timeout = params[:timeout]
        end
        if params[:discoverytimeout]
           RestMCOConfig.restmco_log.debug "Applying discovery timeout"
           RestMCOConfig.restmco_log.debug "discovery timeout : #{params[:discoverytimeout]}"
           mc.discovery_timeout = params[:discoverytimeout]
        end
    end
end
