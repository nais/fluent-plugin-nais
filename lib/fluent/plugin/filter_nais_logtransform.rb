require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisLogtransformFilter < Filter
    Fluent::Plugin.register_filter('nais_logtransform', self)
      
    def configure(conf)
      super
    end
      
    def filter(tag, time, record)
      if record['kubernetes'].is_a?(Hash) && record['kubernetes']['annotations'].is_a?(Hash)
        transformers = record['kubernetes']['annotations']['nais_io/logtransform']
        unless transformers.nil?
          transformers.split(/ *, */).each { |t|
            if t == 'dns_loglevel'
              level = ::Nais::Log::Parser.loglevel_from_dns_response(record['response_code'])
              record['level'] = level unless level.nil?
            elsif t == 'http_loglevel'
              level = ::Nais::Log::Parser.loglevel_from_http_response(record['response_code'])
              record['level'] = level unless level.nil?
            end
          }
        end
      end
      record
    end

  end
end
