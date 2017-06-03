require 'test_helper'

class Trailblazer::LoaderTest < Minitest::Spec
  it "#call" do
    loaded = []
    Trailblazer::Loader.new.(root: "#{Dir.pwd}/test", debug: true) { |f| loaded << f.split("test/").last }

    loaded.must_equal [
      "app/concepts/song/operation/create.rb",
      "app/concepts/song/query/index.rb"
    ]
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

  def test_ordering_mac_osx
    input = [
      "app/models/user.rb",
      "app/concepts/user/callback.rb",
      "app/concepts/user/policy.rb",
      "app/concepts/user/scope.rb",
      "app/concepts/user/cell/row.rb",
      "app/concepts/user/cell/table.rb",
      "app/concepts/user/contract/create.rb",
      "app/concepts/user/contract/update.rb",
      "app/concepts/user/operation/create.rb",
      "app/concepts/user/operation/index.rb",
      "app/concepts/user/operation/show.rb",
      "app/concepts/user/operation/update.rb"
    ]

    expected = [
      "app/concepts/user/callback.rb",
      "app/concepts/user/cell/row.rb",
      "app/concepts/user/cell/table.rb",
      "app/concepts/user/contract/create.rb",
      "app/concepts/user/contract/update.rb",
      "app/concepts/user/policy.rb",
      "app/concepts/user/scope.rb",
      "app/models/user.rb",
      "app/concepts/user/operation/create.rb",
      "app/concepts/user/operation/index.rb",
      "app/concepts/user/operation/show.rb",
      "app/concepts/user/operation/update.rb"
    ]

    input = ::Trailblazer::Loader::SortCreateFirst.(input, {})
    result = ::Trailblazer::Loader::SortOperationLast.(input, {})

    assert_equal expected, result
  end
end
