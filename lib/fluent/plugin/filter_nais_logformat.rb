require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisLogformatFilter < Filter
    Fluent::Plugin.register_filter('nais_logformat', self)
    config_param :logformat, :string, default: ""
    config_param :field, :string, default: "log"
      
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
            r = ::Nais::Log::Parser.parse_accesslog(record[@field])
            unless r.nil?
              r = r[0]
              r[@field] = r.delete('request')
              level = ::Nais::Log::Parser.loglevel_from_http_response(r['response_code'])
              r['level'] = level unless level.nil?
            end
          elsif fmt == 'accesslog_with_processing_time'
            r = ::Nais::Log::Parser.parse_accesslog_with_processing_time(record[@field])
            unless r.nil?
              r[@field] = r.delete('request')
              level = ::Nais::Log::Parser.loglevel_from_http_response(r['response_code'])
              r['level'] = level unless level.nil?
            end
          elsif fmt == 'accesslog_with_referer_useragent'
            r = ::Nais::Log::Parser.parse_accesslog_with_referer_useragent(record[@field])
            unless r.nil?
              r[@field] = r.delete('request')
              level = ::Nais::Log::Parser.loglevel_from_http_response(r['response_code'])
              r['level'] = level unless level.nil?
            end
          elsif fmt == 'accesslog_nginx_ingress'
            r = ::Nais::Log::Parser.parse_accesslog_nginx_ingress(record[@field])
            unless r.nil?
              r[@field] = r.delete('request')
              level = ::Nais::Log::Parser.loglevel_from_http_response(r['response_code'])
              r['level'] = level unless level.nil?
            end
          elsif fmt == 'capnslog'
            r = ::Nais::Log::Parser.parse_capnslog(record[@field])
            unless r.nil?
              r[@field] = r.delete('message')
            end
          elsif fmt == 'logrus'
            r = ::Nais::Log::Parser.parse_logrus(record[@field])
            unless r.nil?
              r[@field] = r.delete('msg')
            end
          elsif fmt == 'gokit'
            r = ::Nais::Log::Parser.parse_gokit(record[@field])
            unless r.nil?
              r['msg'] = r['err'] if r.has_key?('err') && !r.has_key?('msg')
              r[@field] = r.delete('msg')
            end
          elsif fmt == 'rook'
            r = ::Nais::Log::Parser.parse_rook(record[@field])
            unless r.nil?
              r[@field] = r.delete('message')
            end
          elsif fmt == 'redis'
            r = ::Nais::Log::Parser.parse_redis(record[@field])
            unless r.nil?
              r[@field] = r.delete('message')
            end
          elsif fmt == 'coredns'
            r = ::Nais::Log::Parser.parse_coredns(record[@field])
            unless r.nil?
              r[@field] = r.delete('message')
            end
          elsif fmt == 'simple'
            r = ::Nais::Log::Parser.parse_simple(record[@field])
            unless r.nil?
              r[@field] = r.delete('message')
            end
          elsif fmt == 'glog'
            r = ::Nais::Log::Parser.parse_glog(record[@field])
            unless r.nil?
              r['source'] = r['file']+':'+r.delete('line')
              r['component'] = r.delete('file')
              r[@field] = r.delete('message')
            end
          elsif fmt == 'influxdb'
            r = ::Nais::Log::Parser.parse_influxdb(record[@field])
            unless r.nil?
              r[@field] = r.delete('message')
              if r['component'] == 'httpd'
                level = ::Nais::Log::Parser.loglevel_from_http_response(r['response_code'])
                r['level'] = level unless level.nil?
              end
            end
          elsif fmt == 'log15'
            ::Nais::Log::Parser.remap_log15(record)
          elsif fmt == 'jupyter-notebook'
            ::Nais::Log::Parser.parse_jupyterhub_notebook(record)
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
