# Trailblazer::Loader

While Trailblazer enforces a new file structure where you organize by concept, and not by technology, the naming and the structuring within each concept allows different styles.

Trailblazer-loader supports the following directory layouts concurrently.

## Compound-Singular

Per concept, you have one file per abstraction layer (called a _compound_ file). All is singular and reflects the namespace (except for operations which sit in the concept's namespace).

```
app
├── concepts
│   ├── comment
│   │   ├── callback.rb
│   │   ├── cell.rb
│   │   ├── contract.rb
│   │   ├── operation.rb
│   │   ├── policy.rb
│   │   └── views
│   │       ├── grid.haml
│   │       └── show.haml
```

You may nest concepts in concepts.

```
app
├── concepts
│   ├── comment
│   │   ├── contract.rb
│   │   ├── operation.rb
│   │   ├── admin
│   │       ├── contract.rb
│   │       └── operation.rb
```

Note: This is the structuring used in the [Trailblazer book](http://trailblazer.to/books/trailblazer.html).


## Explicit-Singular

Per concept, you have one directory per abstraction layer and one file per class. All is singular and reflects the namespace (except for operations which sit in the concept's namespace).

```
app
├── concepts
│   ├── comment
│   │   ├── contract
│   │   │   ├── create.rb
│   │   │   └── update.rb
│   │   ├── cell
│   │   │   └── form.rb
│   │   ├── operation
│   │   │   ├── create.rb
│   │   │   └── update.rb
│   │   └── views
│   │       ├── grid.haml
│   │       └── show.haml
```

You may nest concepts in concepts.

```
app
├── concepts
│   ├── comment
│   │   ├── contract
│   │   │   ├── create.rb
│   │   │   └── update.rb
│   │   ├── operation
│   │   │   ├── create.rb
│   │   │   └── update.rb
│   │   ├── admin
│   │   │   └── contract
│   │   │       ├── create.rb
│   │   │       └── update.rb
```

## Explicit-Plural

Per concept, you have one pluralized directory per abstraction layer and one file per class.

```
app
├── concepts
│   ├── comment
│   │   ├── contracts
│   │   │   ├── create.rb
│   │   │   └── update.rb
│   │   ├── cells
│   │   │   └── form.rb
│   │   ├── operations
│   │   │   ├── create.rb
│   │   │   └── update.rb
│   │   └── views
│   │       ├── grid.haml
│   │       └── show.haml
```

And, yes, you may nest concepts in concepts.

```
app
├── concepts
│   ├── comment
│   │   ├── contracts
│   │   │   ├── create.rb
│   │   │   └── update.rb
│   │   ├── operation
│   │   │   ├── create.rb
│   │   │   └── update.rb
│   │   ├── admin
│   │   │   └── contracts
│   │   │       ├── create.rb
│   │   │       └── update.rb
```


## Loading order

The loading order is identical for all styles.

1. The loader finds all concept directories.
2. Concept directories are sorted by nesting level, deeper nestings are loaded later as they might reference concepts they're nested in. For example, `concepts/comment/admin` might reuse existing code from `concepts/comment`.
3. Per concept, files are lexically sorted, e.g. `create.rb` will be loaded *before* `update.rb` as we mostly do `Update < Create`.
4. Per concept, operation files will be loaded after all other layer files have been required. This is because abstraction files like representers or contracts should not reference their operation. The operation, howver, as an orchestrating asset needs to refer to various abstraction objects.

Here's a sample of a explicit-singular session.

```ruby
[
  "app/concepts/navigation/cell.rb",
  "app/concepts/session/impersonate.rb",
  "app/concepts/session/operation.rb",
  "app/concepts/user/operation.rb",
  "app/concepts/comment/cell/cell.rb",
  "app/concepts/comment/cell/grid.rb",
  "app/concepts/comment/operation/create.rb",
  "app/concepts/api/v1.rb",
  "app/concepts/thing/callback/default.rb",
  "app/concepts/thing/callback/upload.rb",
  "app/concepts/thing/cell.rb",
  "app/concepts/thing/cell/decorator.rb",
  "app/concepts/thing/cell/form.rb",
  "app/concepts/thing/cell/grid.rb",
  "app/concepts/thing/contract/create.rb",
  "app/concepts/thing/contract/update.rb",
  "app/concepts/thing/policy.rb",
  "app/concepts/thing/signed_in.rb",
  "app/concepts/thing/operation/create.rb",
  "app/concepts/thing/operation/delete.rb",
  "app/concepts/thing/operation/show.rb",
  "app/concepts/thing/operation/update.rb",
  "app/concepts/api/v1/comment/representer/show.rb",
  "app/concepts/api/v1/comment/operation/create.rb",
  "app/concepts/api/v1/comment/operation/show.rb",
  "app/concepts/api/v1/thing/representer/create.rb",
  "app/concepts/api/v1/thing/representer/index.rb",
  "app/concepts/api/v1/thing/representer/show.rb",
  "app/concepts/api/v1/thing/operation/create.rb",
  "app/concepts/api/v1/thing/operation/index.rb",
  "app/concepts/api/v1/thing/operation/update.rb"
]
```

## Mixing

Note that you're free to mix these styles the way it feels right for your project.

For example, you can have compound files and explicit layout in one concept.

```
app
├── concepts
│   ├── comment
│   │   ├── contract.rb     - compound vs.
│   │   ├── operation       -  explicit directory
│   │   │   ├── create.rb
│   │   │   └── update.rb
```

## Namespacing Operations

Normally, operations in Trailblazer use the concept's namespace, e.g. `Comment::Create`, even though they can sit in an explicit file.

```
app
├── concepts
│   ├── comment
│   │   ├── operation       - explicit directory
│   │   │   ├── create.rb   -   contains Comment::Create
│   │   │   └── update.rb
```

You are free to namespace your operations, if you like that better.

```ruby
module Comment::Operation
  class Create < Trailblazer::Operation
```

## Debugging

## Customizing

Trailblazer-loader allows you to inject your own sorting and filtering logic, should you refuse to go mainstream.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trailblazer-loader'
```

## API

```ruby
Trailblazer::Loader.new.() { |file| require_dependency(File.join(Rails.app.root, file)) }
```

`:concepts_root`