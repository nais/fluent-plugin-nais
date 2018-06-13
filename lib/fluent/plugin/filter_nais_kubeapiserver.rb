require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'

module Fluent
  module Plugin
    class NaisKubeApiserverFilter < Fluent::Plugin::Filter
      Fluent::Plugin.register_filter('nais_kubeapiserver', self)
      
      def filter(tag, time, record)
        if record.has_key?('auditID')
          record['x_level'] = record.delete('level')
          record['level'] = 'Audit'
          if record.has_key?('user')
            if record['user'].has_key?('username')
              if m = record['user']['username'].match(/^https:\/\/sts\.windows\.net.*\#(.*)/)
                record['x_username'] = record['user']['username']
                record['user'] = m[1]
              else
                record['user'] = record['user']['username']
              end
            end
          end
          record['method'] = record.delete('verb') if record.has_key?('verb')
          record['uri'] = record.delete('requestURI') if record.has_key?('requestURI')
          record['remote_ip'] = record.delete('sourceIPs') if record.has_key?('sourceIPs')
          record['@timestamp'] = record.delete('stageTimestamp') if record.has_key?('stageTimestamp')
          record.delete('apiVersion')
          record['message'] = record['method'] + ' ' + record['uri'] unless record.has_key?('message')
        end
        record
      end

    end
  end
end
