require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisRewriteKeysFilter < Filter
    Fluent::Plugin.register_filter('nais_rewrite_keys', self)

    def filter(tag, time, record)
      ::Nais::Log::Parser.rewrite_keys(record)
    end
    
  end
end
