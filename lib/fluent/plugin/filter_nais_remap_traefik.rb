require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent
  module Plugin
    class NaisRemapTraefikFilter < Fluent::Plugin::Filter
      Fluent::Plugin.register_filter('nais_remap_traefik', self)
      
      def filter(tag, time, record)
        record['message'] = record.delete('RequestLine') if record.has_key?('RequestLine')
        record.delete('msg') if record['msg'] == ""
        record
      end

    end
  end
end
