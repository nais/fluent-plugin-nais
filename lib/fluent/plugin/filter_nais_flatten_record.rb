require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisFlattenFilter < Filter
    Fluent::Plugin.register_filter('nais_flatten_record', self)
    config_param :keep, :string, default: ""

    def configure(conf)
      super
      @re = @keep == "" ? nil : Regexp.new(@keep)
    end
      
    def filter(tag, time, record)
      ::Nais::Log::Parser.flatten_hash(record, "", @re)
    end
    
  end
end
