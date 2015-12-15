
```ruby
      container = {
        find_concepts: FindConcepts,
        sort_concepts: SortConcepts,
        set_name:      ConceptName,
        concept_files: ConceptFiles,
      }

      require "call_sheet"
      sheet = CallSheet(container: container) do
        map :find_concepts
        map :sort_concepts
      end

      require "pp"
      options[:files] = []
      pp sheet.(options, all: [1])
```

* how to include step at certain position? e.g. from trailblazer-rails
* pass options to all steps