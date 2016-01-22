require "trailblazer/loader/version"
require "pp"

module Trailblazer
  class Loader
    # Please note that this is subject to change - we're still finding out the best way
    # to explicitly load files.
    #
    # NOTE: i will most probably use call_sheet and dry-container here soon.
    def call(options={}, &block)
      options[:concepts_root] ||= "app/concepts/"
      options[:concept_dirs] = concept_dirs

      pipeline = options[:pipeline] || Pipeline[
        FindDirectories,
        FindConcepts,
        SortByLevel,
        Pipeline::Collect[ConceptName, ConceptFiles, SortCreateFirst, SortOperationLast, AddConceptFiles] # per concept.
      ]

      if args = options[:insert] # FIXME: this only implements a sub-set.
        # pipeline = Representable::Pipeline::Insert.(pipeline, *args) # FIXME: implement :before in Pipeline.
        pipeline.last.insert(pipeline.last.index(args.last[:before]), args.first)
      end

      files =  pipeline.([], options).flatten

      debug(options)

      load_files(files, &block)
    end

    def debug(options)
      pp files if options[:debug]
    end

    def concept_dirs
      %w{ callback cell contract operation policy representer view }
    end

    FindDirectories  = ->(input, options) { Dir.glob("#{options[:concepts_root]}**/") }
    # Filter out all directories containing /(callback|cell|contract|operation|policy|representer|view)/
    FindConcepts     = ->(input, options) { input.shift; input.reject { |dir| dir =~ /(#{options[:concept_dirs].join("|")})/ } }
    PrintConcepts    = ->(input, options) { puts "  concepts: #{input.inspect}"; input }

    # lame heuristic, but works for me: sort by directory levels.
    # app/concepts/comment
    # app/concepts/api/v1/comment
    SortByLevel  = ->(input, options) { input.sort { |a, b| a.split("/").size <=> b.split("/").size } }
    # Extract concept name from path, e.g. /api/v1/comment.
    ConceptName   = ->(input, options) { options[:name] = input.sub(options[:concepts_root], "").chomp("/"); [] }
    # Find all .rb files in one particular concept directory, e.g. as in /concepts/comment/*.rb.
    ConceptFiles  = ->(input, options) do
      input + # allow injecting other dependencies, e.g. app/models/comment.rb.

      Dir.glob("#{options[:concepts_root]}#{options[:name]}/*.rb") +        # .rb files directly in this concept.
        Dir.glob("#{options[:concepts_root]}#{options[:name]}/*/*.rb").     # .rb in :concept/operation/*.rb
        find_all { |file| file =~ /(#{options[:concept_dirs].join("|")})/ } # but only those, no sub-concepts!
    end

    # operation files should be loaded after callbacks, policies, and the like: [callback.rb, contract.rb, policy.rb, operation.rb]
    SortOperationLast = ->(input, options) { input.sort { |a, b| a =~ /operation/ && b !~ /operation/ ? 1 : a !~ /operation/ && b =~ /operation/ ? 0 : a <=> b  } }
    SortCreateFirst   = ->(input, options) { input.sort }
    AddConceptFiles   = ->(input, options) { input }

  private

    def load_files(files)
      files.each { |file| yield file }
    end
  end
end

require "trailblazer/loader/pipeline"
