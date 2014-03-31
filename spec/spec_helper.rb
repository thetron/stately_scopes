require 'bundler'
Bundler.require(:default)

require 'active_record'
require 'scoping/with_state'
require 'pp'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'minitest/pride'

module MiniTest
  class Spec
    class << self
      alias_method :context, :describe
    end
  end
end


#ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.define do
  create_table :widgets do |table|
    table.column :fake, :boolean
  end
end

def reload_widget
  Object.send(:remove_const, :Widget)
  load 'support/widget.rb'
end

load 'support/widget.rb'
