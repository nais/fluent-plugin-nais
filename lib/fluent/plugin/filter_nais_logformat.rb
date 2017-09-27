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
      r = nil
      if record['kubernetes'].is_a?(Hash) && record['kubernetes']['annotations'].is_a?(Hash)
        fmt = record['kubernetes']['annotations']['nais_io/logformat']
        if fmt == 'accesslog'
          r = ::Nais::Log::Parser.parse_accesslog(record['log'])
          unless r.nil?
            r = r[0]
            r['log'] = r.delete('request')
          end
        elsif fmt == 'accesslog_with_processing_time'
          r = ::Nais::Log::Parser.parse_accesslog_with_processing_time(record['log'])
          r['log'] = r.delete('request') unless r.nil?
        elsif fmt == 'glog'
          r = ::Nais::Log::Parser.parse_glog(record['log'])
          unless r.nil?
            r['component'] = r.delete('file')+':'+r.delete('line')
            r['log'] = r.delete('message')
          end
        end
      end
      if r.nil?
        record
      else
        record.merge(r)
      end
    end
    
  end
end
