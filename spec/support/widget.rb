class Widget < ActiveRecord::Base
  include Scoping::WithState
  scope :faked, -> { where(:fake => true) }
end
