require "trailblazer/loader/version"
require "trailblazer"
require "pp"

module Trailblazer
  class Loader < Trailblazer::Operation
    CONCEPT_DIRS =
      %w{ callback  cell  contract  operation  policy   representer  view
          callbacks cells contracts operations policies representers views }
    private_constant :CONCEPT_DIRS

    step :options_setup
    step :pipeline_setup!
    step :insert!
    step :prepend!
    step :files
    success :debug

    def options_setup(options, *)
      options[:root]          ||= "."
      options[:concepts_root] ||= "#{options[:root]}/app/concepts/"
      options[:concept_dirs]  ||= CONCEPT_DIRS
    end

    def pipeline_setup!(options, *)
      return true if options[:pipeline]

      options[:pipeline] = default_circuit
    end

    def insert!(options, *) # FIXME: this only implements a sub-set.
      return true unless options[:insert]

      # pipeline = Representable::Pipeline::Insert.(pipeline, *args) # FIXME: implement :before in Pipeline.
      options[:pipeline].last.insert(pipeline.last.index(args.last[:before]), args.first)
    end

    def prepend!(options, *)
      return true unless options[:prepend]

      options[:pipeline] << args
    end

    # Please note that this is subject to change - we're still finding out the best way
    # to explicitly load files.
    def files(options, pipeline:, **)
      options[:files] = pipeline.([], options).flatten
    end

    def debug(options, files:, **)
      return unless options[:debug]

      pp files
    end

  private
    def default_circuit
      Pipeline[
        FindDirectories,
        FindConcepts,
        SortByLevel,
        Pipeline::Collect[
          ConceptName,
          ConceptFiles,
          SortCreateFirst,
          SortOperationLast,
          AddConceptFiles
        ]# per concept.
      ]
    end

    FindDirectories  = ->(input, options) { Dir.glob("#{options[:concepts_root]}**/") }
    # Filter out all directories containing /(callback|cell|contract|operation|policy|representer|view)/
    FindConcepts     = ->(input, options) { input.reject { |dir| (dir.split(File::SEPARATOR) & options[:concept_dirs]).any? } }
    # lame heuristic, but works for me: sort by directory levels.
    # app/concepts/comment
    # app/concepts/api/v1/comment
    SortByLevel  = ->(input, options) { input.sort { |a, b| a.split(File::SEPARATOR).size <=> b.split(File::SEPARATOR).size } }
    # Extract concept name from path, e.g. /api/v1/comment.
    ConceptName   = ->(input, options) { options[:name] = input.sub(options[:concepts_root], "").chomp("/"); [] }
    # Find all .rb files in one particular concept directory, e.g. as in /concepts/comment/*.rb.
    ConceptFiles  = ->(input, options) do
      input + # allow injecting other dependencies, e.g. app/models/comment.rb.

      Dir.glob("#{options[:concepts_root]}#{options[:name]}/*.rb") +        # .rb files directly in this concept.
        Dir.glob("#{options[:concepts_root]}#{options[:name]}/*/*.rb").     # .rb in :concept/operation/*.rb
        find_all { |file| (file.split(File::SEPARATOR) & options[:concept_dirs]).any? } # but only those, no sub-concepts!
    end
    # operation files should be loaded after callbacks, policies, and the like: [callback.rb, contract.rb, policy.rb, operation.rb]
    SortOperationLast = ->(input, options) { input.sort { |a, b| a =~ /operation/ && b !~ /operation/ ? 1 : a !~ /operation/ && b =~ /operation/ ? -1 : a <=> b  } }
    SortCreateFirst   = ->(input, options) { input.sort }
    AddConceptFiles   = ->(input, options) { input }
  end
end

require "trailblazer/loader/pipeline"
