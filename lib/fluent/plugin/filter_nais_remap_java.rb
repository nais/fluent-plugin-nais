require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisRemapJavaFilter < Filter
    Fluent::Plugin.register_filter('nais_remap_java', self)
      
    def configure(conf)
      super
    end
      
    def filter(tag, time, record)
      ::Nais::Log::Parser.remap_java_fields(record)
    end
    
  end
end
