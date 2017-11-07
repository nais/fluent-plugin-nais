require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisKeywordsFilter < Filter
    Fluent::Plugin.register_filter('nais_keywords', self)
    config_param :field, :string
    config_param :regex, :string

    def configure(conf)
      super
      @re = Regexp.new(@regex)
    end
      
    def filter(tag, time, record)
      keywords = ::Nais::Log::Parser.get_keywords(record['message'].to_s+' '+record['stack_trace'].to_s, @re)
      record[@field] = keywords unless keywords.nil?
      record
    end
    
  end
end
