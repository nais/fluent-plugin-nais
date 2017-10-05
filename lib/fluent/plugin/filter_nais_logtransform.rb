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
      r = nil
      if record['kubernetes'].is_a?(Hash) && record['kubernetes']['annotations'].is_a?(Hash)
        transformers = record['kubernetes']['annotations']['nais_io/logtransform']
        unless transformers.nil?
          transformer.split(/ *, */).each { |t|
            if t == 'dns_loglevel'
              r = ::Nais::Log::Parser.loglevel_from_dns_response(record['response_code'])
              record['level'] = r unless r.nil?
            elsif t == 'http_loglevel'
              r = ::Nais::Log::Parser.loglevel_from_http_response(record['response_code'])
              record['level'] = r unless r.nil?
            end
          }
        end
      end
    end

  end
end
