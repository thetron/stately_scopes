require 'spec_helper'

describe StatelyScopes do
  before do
    reload_stately_scopes
    reload_widget
  end

  it "aliases the scope method" do
    Widget.public_methods.must_include :scope_without_state, "Expected widget to alias `scope'"
  end

  describe ".has_scoped_state?" do
    context "when object is in the scope" do
      it "returns true" do
        widget = Widget.create(:fake => true)
        widget.has_scoped_state?(:faked).must_equal true
      end
    end

    context "when object is outside the scope" do
      it "returns false" do
        widget = Widget.create(:fake => false)
        widget.has_scoped_state?(:faked).must_equal false
      end
    end
  end

  describe "#scope_with_state" do
    it "defines a scope" do
      Widget.public_methods.must_include :faked
    end

    it "defines a state instance method" do
      Widget.new.public_methods.must_include :faked?
    end
  end

  describe "configuration" do
    context "when alias_scope_method = false" do
      it "does not alias the scope method" do
        StatelyScopes.configure { |c| c.alias_scope_method = false }
        reload_widget
        Widget.public_methods.wont_include :scope_without_state, "Expected widget to not alias `scope'"
      end
    end

    describe "#configure" do
      it "yields the configuration" do
        StatelyScopes.configure do |config|
          config.must_equal StatelyScopes::Configuration.configuration
        end
      end
    end

    describe "#configuration" do
      it "sets alias_scope_method to true by default" do
        StatelyScopes.configuration.alias_scope_method.must_equal true
      end
    end
  end
end
