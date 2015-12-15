require "trailblazer/loader/version"

module Trailblazer
  class Loader
    # Please note that this is subject to change - we're still finding out the best way
    # to explicitly load files.
    def call(app_root)
      operations = Dir.glob("app/concepts/**/operation*").sort { |a, b| a.split("/").size <=> b.split("/").size }
      # lame heuristic, but works for me: sort by nested levels.
      # app/concepts/comment
      # app/concepts/api/v1/comment



      operations.each do |f|
        path  = f.sub("app/concepts/", "")
        model = path.sub("/operation","").chomp(".rb")

        concept = model # comment, api/v1/comment, ...

        puts "digging through #{concept}"

        puts "@@@@@---> #{app_root}/app/models/#{model}" unless File.exist?("#{app_root}/app/models/#{model}.rb")

        # app/models/ # FIXME: where's the namespace here?
        yield "#{app_root}/app/models/#{model}" if File.exist?("#{app_root}/app/models/#{model}.rb") # load the model file, first (thing.rb).


        [:contract, :representer, :callback, :cell, :policy].each do |asset|
          file = "#{app_root}/app/concepts/#{concept}/#{asset}"
          puts "loading extension... #{file.inspect}"
          yield file if File.exist?("#{file}.rb") # load the model file, first (thing.rb).
        end

        # concepts/:namespace/operation.rb
        yield "#{app_root}/#{f}" if File.exists?("#{app_root}/#{f}.rb")
      end
    end
  end
end
