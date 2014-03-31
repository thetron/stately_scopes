require "active_record/scoping/with_state/version"

module ActiveRecord
  module Scoping
    module WithState
      extend ActiveSupport::Concern

      included do
        alias_method_chain :scope, :state
      end

      def has_scoped_state?(name)
        self.class.send(name.to_sym).exists?(self.id)
      end

      module ClassMethods
        def scope_with_state(name, body, &block)
          scope_without_state name, body, &block
          class_eval "def #{name}?() self.has_scoped_state?(#{name}) end"
        end

        def configure(&block)
          yield(configuration)
        end

        def configuration
          @configuration ||= OpenStruct.new(:alias_scope_method => true)
        end
      end
    end
  end
end
