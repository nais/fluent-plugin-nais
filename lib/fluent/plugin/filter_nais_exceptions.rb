require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisExceptionsFilter < Filter
    Fluent::Plugin.register_filter('nais_exceptions', self)

    def configure(conf)
      super
    end
      
    def filter(tag, time, record)
      ex = ::Nais::Log::Parser.get_exceptions(record['message'].to_s+' '+record['stack_trace'].to_s)
      record['exception'] = ex unless ex.nil?
      record
    end
    
  end
end
