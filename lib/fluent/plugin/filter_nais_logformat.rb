require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisLogformatFilter < Filter
    Fluent::Plugin.register_filter('nais_logformat', self)
    config_param :logformat, :string, default: ""
      
    def configure(conf)
      super
    end
      
    def filter(tag, time, record)
      r = nil
      formats = @logformat
      if record['kubernetes'].is_a?(Hash) && record['kubernetes']['annotations'].is_a?(Hash)
        formats = record['kubernetes']['annotations']['nais_io/logformat']
      end
      unless formats.nil? || formats == ""
        formats.split(',').each {|fmt|
          if fmt == 'accesslog'
            r = ::Nais::Log::Parser.parse_accesslog(record['log'])
            unless r.nil?
              r = r[0]
              r['log'] = r.delete('request')
              level = ::Nais::Log::Parser.loglevel_from_http_response(r['response_code'])
              r['level'] = level unless level.nil?
            end
          elsif fmt == 'accesslog_with_processing_time'
            r = ::Nais::Log::Parser.parse_accesslog_with_processing_time(record['log'])
            unless r.nil?
              r['log'] = r.delete('request')
              level = ::Nais::Log::Parser.loglevel_from_http_response(r['response_code'])
              r['level'] = level unless level.nil?
            end
          elsif fmt == 'accesslog_with_referer_useragent'
            r = ::Nais::Log::Parser.parse_accesslog_with_referer_useragent(record['log'])
            unless r.nil?
              r['log'] = r.delete('request')
              level = ::Nais::Log::Parser.loglevel_from_http_response(r['response_code'])
              r['level'] = level unless level.nil?
            end
          elsif fmt == 'capnslog'
            r = ::Nais::Log::Parser.parse_capnslog(record['log'])
            unless r.nil?
              r['log'] = r.delete('message')
            end
          elsif fmt == 'logrus'
            r = ::Nais::Log::Parser.parse_logrus(record['log'])
            unless r.nil?
              r['log'] = r.delete('msg')
            end
          elsif fmt == 'gokit'
            r = ::Nais::Log::Parser.parse_gokit(record['log'])
            unless r.nil?
              r['msg'] = r['err'] if r.has_key?('err') && !r.has_key?('msg')
              r['log'] = r.delete('msg')
            end
          elsif fmt == 'rook'
            r = ::Nais::Log::Parser.parse_rook(record['log'])
            unless r.nil?
              r['log'] = r.delete('message')
            end
          elsif fmt == 'redis'
            r = ::Nais::Log::Parser.parse_redis(record['log'])
            unless r.nil?
              r['log'] = r.delete('message')
            end
          elsif fmt == 'coredns'
            r = ::Nais::Log::Parser.parse_coredns(record['log'])
            unless r.nil?
              r['log'] = r.delete('message')
            end
          elsif fmt == 'simple'
            r = ::Nais::Log::Parser.parse_simple(record['log'])
            unless r.nil?
              r['log'] = r.delete('message')
            end
          elsif fmt == 'glog'
            r = ::Nais::Log::Parser.parse_glog(record['log'])
            unless r.nil?
              r['source'] = r['file']+':'+r.delete('line')
              r['component'] = r.delete('file')
              r['log'] = r.delete('message')
            end
          elsif fmt == 'influxdb'
            r = ::Nais::Log::Parser.parse_influxdb(record['log'])
            unless r.nil?
              r['log'] = r.delete('message')
              if r['component'] == 'httpd'
                level = ::Nais::Log::Parser.loglevel_from_http_response(r['response_code'])
                r['level'] = level unless level.nil?
              end
            end
          elsif fmt == 'log15'
            ::Nais::Log::Parser.remap_log15(record)
          end
          break unless r.nil?
        }
      end
      if r.nil?
        record
      else
        record.merge(r)
      end
    end
  end
end
