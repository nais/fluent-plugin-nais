require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisLogformatFilter < Filter
    Fluent::Plugin.register_filter('nais_logformat', self)
      
    def configure(conf)
      super
    end
      
    def filter(tag, time, record)
      fmt = record['kubernetes']['annotations']['nais.io/logformat']
      r = nil
      if fmt == 'accesslog'
        r = ::Nais::Log::Parser.parse_accesslog(record['log'])
        r = r[0] unless r.nil?
      elsif fmt == 'accesslog_with_processing_time'
        r = ::Nais::Log::Parser.parse_accesslog_with_processing_time(record['log'])
      elsif fmt == 'glog'
        r = ::Nais::Log::Parser.parse_glog(record['log'])
      end
      if r.nil?
        record
      else
        record.merge(r)
      end
    end
    
  end
end
