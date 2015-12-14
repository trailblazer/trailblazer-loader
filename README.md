# Trailblazer::Loader

## Experimental!

Note that this is not the finalized version of `trailblazer-loader`. We still need more input from you.

Expect many minor version bumps.

## Loading order

Per concept. Lexically sorted. Then, sorted by depths, as follows.

```
app/concepts/blog/operation.rb
app/concepts/comment/operation.rb
app/concepts/post/operation.rb
app/concepts/api/v1/comment/operation.rb
app/concepts/api/v1/post/operation.rb
```

1. Model. The model does not have dependencies to other layers. If it does, you're doing it wrong.
2. Policy
3. Representer
4. Form
5. Callbacks, etc.
6. Operation. As an orchestrating object, this needs to be loaded last. It is very common for operations to reference form classes, etc. on the class level.
 first create.rb
 then operations.rb {configurable, could also be crud.rb}

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trailblazer-loader'
```

## API

```ruby
Trailblazer::Loader.new.(Rails.app.root) { |file| require_dependency(file) }
```


## File Layout

```
app
├── concepts
│   ├── comment
│   │   ├── cell.rb        [optional]
│   │   ├── contract.rb    [optional]
│   │   ├── operation.rb
│   │   ├── policy.rb      [optional]
│   │   ├── representer.rb [optional]
│   │   ├── views
│   │   │   ├── show.haml
│   │   │   ├── list.haml
│   │   │   ├── comment.css.sass
```

### Alternative "explicit" layout

This works for cell, contract, operation, policy, representer and twin.

```
app
├── concepts
│   ├── comment
│   │   ├── operation
│   │   │   ├── create.rb
│   │   │   ├── update.rb
```

### Nested

```
app
├── concepts
│   ├── comment
│   │   ├── cell
│   │   │   ├── single
│   │   │   │   ├── homepage.rb
│   │   │   │   ├── search.rb
│   │   │   │   ├── views
│   │   │   │   │   ├── homepage.haml
│   │   │   │   │   ├── search.haml
│   │   │   ├── collection
```