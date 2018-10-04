require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'

module Fluent::Plugin
  class NaisRemapKubernetesFilter < Filter
    Fluent::Plugin.register_filter('nais_remap_kubernetes', self)
    config_param :labels, :string, default: ""
      
    def configure(conf)
      super
    end
      
    def filter(tag, time, record)
      record["category"] = record.delete("stream") if record.has_key?("stream")
      if record["docker"].is_a?(Hash)
        record["container"] = record["docker"]["container_id"]
        record.delete("docker")
      end
      if record["kubernetes"].is_a?(Hash)
        record["host"] = record["kubernetes"]["host"]
        record["namespace"] = record["kubernetes"]["namespace_name"]
        record["application"] = record["kubernetes"]["container_name"]
        record["pod"] = record["kubernetes"]["pod_name"]
        if record["kubernetes"]["labels"].is_a?(Hash)
          unless @labels.nil? || @labels == ""
            @labels.split(',').each {|label|
              if record["kubernetes"]["labels"].has_key?(label) && !record["kubernetes"]["labels"][label].nil? && record["kubernetes"]["labels"][label] != ""
                record[label] = record["kubernetes"]["labels"][label]
              end
            }
          end
        end
        record.delete("kubernetes")
      end
      record
    end
    
  end
end
