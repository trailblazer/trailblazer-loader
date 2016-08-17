require 'test_helper'

class Trailblazer::LoaderTest < Minitest::Spec
  it "#call" do
    loaded = []
    Trailblazer::Loader.new.(root: "#{Dir.pwd}/test", debug: true) { |f| loaded << f }

    loaded.must_equal ["/home/nick/projects/trailblazer-loader/test/app/concepts/song/operation/create.rb",
      "/home/nick/projects/trailblazer-loader/test/app/concepts/song/query/index.rb"]
  end

  it do
    input = [
      "app/concepts/order/cell/index.rb",
      "app/concepts/order/operation/update.rb",
      "app/concepts/order/cell/part.rb",
      "app/concepts/order/operation/index.rb",
      "app/concepts/order/cell/update.rb",
      "app/concepts/order/operation/search.rb",
      "app/concepts/order/cell/create.rb",
      "app/concepts/order/policy.rb",
      "app/concepts/order/cell.rb",
      "app/concepts/order/contract/update.rb",
      "app/concepts/order/contract/create.rb",
      "app/concepts/order/operation/from_traject.rb",
      "app/concepts/order/operation/create.rb",
      "app/concepts/contractor/operation.rb"
    ]

    expected = [
      "app/concepts/order/cell.rb",
      "app/concepts/order/cell/create.rb",
      "app/concepts/order/cell/index.rb",
      "app/concepts/order/cell/part.rb",
      "app/concepts/order/cell/update.rb",
      "app/concepts/order/contract/create.rb",
      "app/concepts/order/contract/update.rb",
      "app/concepts/order/policy.rb",
      "app/concepts/contractor/operation.rb",
      "app/concepts/order/operation/create.rb",
      "app/concepts/order/operation/from_traject.rb",
      "app/concepts/order/operation/index.rb",
      "app/concepts/order/operation/search.rb",
      "app/concepts/order/operation/update.rb",
    ]

    input = ::Trailblazer::Loader::SortCreateFirst.(input, {})
    result = ::Trailblazer::Loader::SortOperationLast.(input, {})

    result.must_equal expected
  end
end
