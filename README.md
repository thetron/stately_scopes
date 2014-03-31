# ActiveRecord::Scoping::WithState

So small, it's almost silly - but it is kinda helpful.

I've found that when developing Rails apps, I tend to almost always pair each
scope with an instance method which returns a boolean indicating whether the
object is included inside that scope.

This gem simply automatically creates that method for you. Nothing super fancy,
and you might consider replacing the state methods with your own, more
efficient, implementations - but it's great for early stages of development, or
providing a comparative case for unit tests.


## Example

Using a small `Event` model:

```ruby
class Event < ActiveRecord::Base
  include ActiveRecord::Scoping::WithState
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
or
`scope :spam -> { ... }` will generate `.spam?`  
You get the picture.


## Configuration

You can turn off the automatic aliasing of `scope`, and explicitly call
`scope_with_state` instead, for each scope that you'd like to have generated
state method for. To do that, add the following initializer:

```ruby
# config/initializers/active_record-scoping-with_state.rb
ActiveRecord::Scoping::WithState.configure do |config|
  config.alias_scope_method = false
end
```


## Caveats

It should be noted that the instance methods do use a database query in order
to establish a model instance's state. Arguably not ideal, however the query is
as efficient as possible (I think?).

If you have performance concerns, I would recommend overriding the generated
state methods for production use.


## Contributing

1. Fork it ( http://github.com/thetron/active_record-scoping-with_state/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
