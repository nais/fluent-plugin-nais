require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisPrefixFilter < Filter
    Fluent::Plugin.register_filter('nais_prefix_fields', self)
    config_param :prefix, :string
    config_param :regex, :string
    
    
    def configure(conf)
      super
      @re = Regexp.new(@regex)
    end
      
    def filter(tag, time, record)
      ::Nais::Log::Parser.prefix_fields(record, @prefix, @re)
    end
    
  end
end
