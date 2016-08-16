require 'test_helper'

class Trailblazer::LoaderTest < Minitest::Test
  def test_it_has_a_version_number
    refute_nil ::Trailblazer::Loader::VERSION
  end

  def test_ordering
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

    assert_equal expected, result
  end
end
