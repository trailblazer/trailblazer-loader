require "trailblazer/loader/version"
require "pp"

module Trailblazer
  class Loader

    def concept_dirs
      %w{ callback  cell  contract  operation  policy   representer  view
          callbacks cells contracts operations policies representers views }
    end

    # Please note that this is subject to change - we're still finding out the best way
    # to explicitly load files.
    def call(options={}, &block)
      options[:root]          ||= "."
      options[:concepts_root] ||= "#{options[:root]}/app/concepts/"
      options[:concept_dirs]  ||= concept_dirs

      pipeline = options[:pipeline] || default_circuit

      if args = options[:insert] # FIXME: this only implements a sub-set.
        # pipeline = Representable::Pipeline::Insert.(pipeline, *args) # FIXME: implement :before in Pipeline.
        pipeline.last.insert(pipeline.last.index(args.last[:before]), args.first)
      end
      if args = options[:prepend]
        pipeline << args
      end

      files =  pipeline.([], options).flatten

      debug(files, options)

      load_files(files, &block)
    end

    def default_circuit
      Pipeline[
        FindDirectories,
        FindConcepts,
        SortByLevel,
        Pipeline::Collect[ConceptName, ConceptFiles, SortCreateFirst, SortOperationLast, AddConceptFiles] # per concept.
      ]
    end

    def debug(files, options)
      pp files if options[:debug]
    end

    FindDirectories  = ->(input, options) { Dir.glob("#{options[:concepts_root]}**/") }
    # Filter out all directories containing /(callback|cell|contract|operation|policy|representer|view)/
    FindConcepts     = ->(input, options) { input.reject { |dir| (dir.split(File::SEPARATOR) & options[:concept_dirs]).any? } }
    PrintConcepts    = ->(input, options) { puts "  concepts: #{input.inspect}"; input }

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


    # FindRbFiles       = ->(input, options) { input + Dir.glob("#{options[:concepts_root]}#{options[:name]}/*.rb") }
  private

    def load_files(files)
      files.each { |file| yield file }
    end
  end
end

require "trailblazer/loader/pipeline"
