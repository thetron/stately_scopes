require 'active_support/concern'
require 'active_support/core_ext/module/aliasing'

module StatelyScopes
  extend ActiveSupport::Concern

  included do
    class_eval do
      class << self
        alias_method_chain :scope, :state if StatelyScopes.configuration.alias_scope_method
      end
    end
  end

  def has_scoped_state?(name)
    self.class.send(name.to_sym).exists?(self.id)
  end

  module ClassMethods
    def scope_with_state(name, body, &block)
      if StatelyScopes.configuration.alias_scope_method
        scope_without_state name, body, &block
      else
        scope name, body, &block
      end
      class_eval "def #{name}?() self.has_scoped_state?(:#{name}) end"
    end
  end

  class << self
    def configure(&block)
      yield(StatelyScopes::Configuration.configuration)
    end

    def configuration
      StatelyScopes::Configuration.configuration
    end
  end

  class Configuration
    def self.configuration
      @@configuration ||= OpenStruct.new(:alias_scope_method => true)
    end
  end
end
