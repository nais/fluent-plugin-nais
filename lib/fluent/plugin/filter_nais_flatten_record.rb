require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisFlattenFilter < Filter
    Fluent::Plugin.register_filter('nais_flatten_record', self)
      
    def configure(conf)
      super
    end
      
    def filter(tag, time, record)
      ::Nais::Log::Parser.flatten_hash(record)
    end
    
  end
end
