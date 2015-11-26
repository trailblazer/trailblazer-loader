# Trailblazer::Loader


## Loading order

Per concept.

1. Model. The model does not have dependencies to other layers. If it does, you're doing it wrong.
2. Policy
3. Representer
4. Form
5. Callbacks, etc.
6. Operation. As an orchestrating object, this needs to be loaded last. It is very common for operations to reference form classes, etc. on the class level.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trailblazer-loader'
```
