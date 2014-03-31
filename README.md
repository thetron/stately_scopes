# StatelyScopes

[![Build Status](https://travis-ci.org/thetron/stately_scopes.svg?branch=master)](https://travis-ci.org/thetron/stately_scopes)
[![Code Climate](https://codeclimate.com/github/thetron/stately_scopes.png)](https://codeclimate.com/github/thetron/stately_scopes)

An ActiveRecord extension so small, it's almost silly - but it is kinda helpful.

I've found that when developing Rails apps, I tend to almost always pair each
scope with an instance method which returns a boolean indicating whether the
object is included inside a given scope.

This gem simply automates that method creation for you. Nothing super fancy,
and you might consider replacing the state methods with your own, more
efficient, implementations - but it's great for early stages of development, or
providing a comparative case for unit tests.


## Example

Using a small `Event` model:

```ruby
class Event < ActiveRecord::Base
  include StatelyScopes
  scope :upcoming, -> { where ("starts_at > ?", Time.now) }
end
```

```ruby
old_event = Event.create(:starts_at => 1.day.ago)
upcoming_event = Event.create(:starts_at => 1.day.from_now)

old_event.upcoming? # => false
upcoming_event.upcoming? # => true
```


## Installation

Add this line to your application's Gemfile:

    gem 'active_record-scoping-with_state'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record-scoping-with_state


## Usage

The gem automatically aliases the existing `scope` method provided by
ActiveRecord, so all of your models will have the new state methods by default.

The helper methods will have the same name as your scopes, with a `?` appended.

Eg:

`scope :upcoming, -> { ... }` will generate `.upcoming?`  
and  
`scope :spam -> { ... }` will generate `.spam?`

You get the picture.

If you're wanting to avoid the automatically generated state methods on a given
scope, you can simply use `scope_without_state` instead of `scope`.


## Configuration

You can turn off the automatic aliasing of `scope`, and explicitly call
`scope_with_state` instead, for each scope that you'd like to have generated
state method for. To do that, add the following initializer:

```ruby
# config/initializers/active_record-scoping-with_state.rb
StatelyScopes.configure do |config|
  config.alias_scope_method = false
end
```


## Caveats

It should be noted that the instance methods do use a database query in order
to establish a model instance's state. Arguably not ideal, however the query is
as efficient as possible (I think?).

If you have performance concerns, I would recommend overriding the generated
state methods for production use. In this case, this gem can still be used
in test cases by calling `.has_scoped_state(scope_name)` on your model instances.
In this way, you can help validate that your overridden state methods are
congruent to the conditions in your scope.

Using the above `Event` model again, however the `upcoming?` method has been
overridden with:

```ruby
# app/models/event.rb

def upcoming?
  self.starts_at > Time.now
end
```

Obviously this is better than hitting the database, however we'd like to write
a test case that ensures that the new method is the equivalent of the generated
one - so we can do something like this:

```ruby
future_event = Event.create(:starts_at => 5.days.from_now)
assert_equal future_event.upcoming?, future_event.has_scoped_state?(:upcoming)
```

## Contributing

1. Fork it ( http://github.com/thetron/active_record-scoping-with_state/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
