require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisPrefixFilter < Filter
    Fluent::Plugin.register_filter('nais_prefix_nonstandard', self)
      
    def configure(conf)
      super
    end
      
    def filter(tag, time, record)
      ::Nais::Log::Parser.prefix_nonstandard_fields(record)
    end
    
  end
end
