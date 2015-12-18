module Trailblazer
  # WARNING: this will be removed soon with Uber::Pipeline or CallSheet.
  class Loader::Pipeline < Array
    Stop = Class.new

    # options is mutuable.
    def call(input, options)
      inject(input) do |memo, block|
        res = evaluate(block, memo, options)
        return(Stop)if Stop == res
        res
      end
    end

  private
    def evaluate(block, input, options)
      block.call(input, options)
    end


    module Macros # TODO: explicit test.
      # Macro to quickly modify an array of functions via Pipeline::Insert and return a
      # Pipeline instance.
      def insert(functions, new_function, options)
        Pipeline.new(Pipeline::Insert.(functions, new_function, options))
      end
    end
    extend Macros

    # Collect applies a pipeline to each element of input.
    class Collect < self
      # when stop, the element is skipped. (should that be Skip then?)
      def call(input, options)
        arr = []
        input.each_with_index do |item_fragment, i|
          result = super(item_fragment, options.merge(index: i)) # DISCUSS: NO :fragment set.
          Stop == result ? next : arr << result
        end
        arr
      end
    end # Collect

    module Function
      class Insert
        def call(arr, func, options)
          arr = arr.dup
          delete!(arr, func) if options[:delete]
          replace!(arr, options[:replace], func) if options[:replace]
          arr
        end

      private
        def replace!(arr, old_func, new_func)
          arr.each_with_index { |func, index|
            if func.is_a?(Collect)
              arr[index] = Collect[*Pipeline::Insert.(func, new_func, replace: old_func)]
            end

            arr[index] = new_func if func==old_func
          }
        end

        def delete!(arr, removed_func)
          arr.delete(removed_func)

          # TODO: make nice.
          arr.each_with_index { |func, index|
            if func.is_a?(Collect)
              arr[index] = Collect[*Pipeline::Insert.(func, removed_func, delete: true)]
            end
          }
        end
      end
    end

    Insert = Function::Insert.new
  end
end