require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisMergeJsonFilter < Filter
    Fluent::Plugin.register_filter('nais_merge_json', self)
    config_param :field, :string
      
    def configure(conf)
      super
    end
      
    def filter(tag, time, record)
      ::Nais::Log::Parser.merge_json_field(record, @field)
    end
    
  end
end
