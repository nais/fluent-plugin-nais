require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'

module Fluent
  module Plugin
    class NaisKubewatchFilter < Fluent::Plugin::Filter
      Fluent::Plugin.register_filter('nais_kubewatch', self)
      
      def filter(tag, time, record)
        if record['source'].is_a?(Hash)
          if record['source'].has_key?('host')
            record['host'] = record['source']['host']
          end
          if record['source'].has_key?('component')
            record['source'] = record['source']['component']
          end
        end
        record['event'] = record.delete('reason') if record.has_key?('reason')
        type = record.delete('type')
        if type == 'Normal'
          record['level'] = 'Info'
        elsif !type.nil?
          record['level'] = type
        end
        if record.has_key?('involvedObject')
          if record['involvedObject']['kind'] == 'Pod'
            if record['involvedObject']['fieldPath'] =~ /^spec.containers\{([^\}]+)\}$/
              record['application'] = $1
              record['pod'] = record['involvedObject']['name']
              record['namespace'] = record['involvedObject']['namespace']
              record.delete('involvedObject')
              record.delete('container')
            end
          end
          if record.has_key?('involvedObject')
            record['involvedObject'].delete('uid')
            record['involvedObject'].delete('resourceVersion')
            record['involvedObject'].delete('apiVersion')
          end
        end
        record.delete('count')
        record.delete('firstTimestamp')
        record.delete('lastTimestamp')
        record.delete('metadata')
        record
      end
      
    end
  end
end