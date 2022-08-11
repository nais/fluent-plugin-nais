require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisDropNestedElementsFilter < Filter
    Fluent::Plugin.register_filter('nais_drop_nested_elements', self)
    config_param :keep, :string, default: ""

    def configure(conf)
      super
      @re = @keep == "" ? nil : Regexp.new(@keep)
    end

    def filter(tag, time, record)
      ::Nais::Log::Parser.drop_nested_elements(record, @re)
    end
    
  end
end
