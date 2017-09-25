require "fluent/plugin/nais/version"
require 'fluent/plugin/filter'
require 'nais/log/parser'

module Fluent::Plugin
  class NaisEnvironmentFilter < Filter
    Fluent::Plugin.register_filter('nais_environment', self)

    def configure(conf)
      super
    end
      
    def filter(tag, time, record)
      record["cluster"] = "#{ENV['CLUSTER_NAME']}"
      record["envclass"] = "#{ENV['CLUSTER_ENVCLASS']}"
      record
    end
    
  end
end
