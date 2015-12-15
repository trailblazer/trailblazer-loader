require "trailblazer/loader/version"
require "representable/pipeline"

module Trailblazer
  class Loader
    # Please note that this is subject to change - we're still finding out the best way
    # to explicitly load files.
    #
    # NOTE: i will most probably use call_sheet and dry-container here soon.
    def call(options={}, &block)
      options[:concepts_root] ||= "app/concepts/"

      pipeline = options[:pipeline] || Representable::Pipeline[
        FindConcepts,
        SortConcepts,
        Representable::Collect[ConceptName, ConceptFiles] # per concept.
      ]

      if args = options[:insert] # FIXME: this only implements a sub-set.
        # pipeline = Representable::Pipeline::Insert.(pipeline, *args) # FIXME: implement :before in Pipeline.
        pipeline[2].insert(pipeline[2].index(args.last[:before]), args.first)
      end

      files =  pipeline.([], options).flatten

      # require "pp"
      # pp files

      load_files(files, &block)
    end

    FindConcepts  = ->(input, options) { Dir.glob("#{options[:concepts_root]}**/") }
    # lame heuristic, but works for me: sort by nested levels.
    # app/concepts/comment
    # app/concepts/api/v1/comment
    SortConcepts  = ->(input, options) { input.sort { |a, b| a.split("/").size <=> b.split("/").size } }
    # Extract concept name from path, e.g. /api/v1/comment.
    ConceptName   = ->(input, options) { options[:name] = input.sub(options[:concepts_root], "").chomp("/"); [] }
    # Find all .rb files in one particular concept directory, e.g. as in /concepts/comment/*.rb.
    ConceptFiles  = ->(input, options) { input += Dir.glob("#{options[:concepts_root]}#{options[:name]}/*.rb") }

  private

    def load_files(files)
      files.each { |file| yield file }
    end
  end
end
