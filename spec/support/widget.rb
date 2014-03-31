class Widget < ActiveRecord::Base
  include StatelyScopes
  scope :faked, -> { where(:fake => true) }
end
