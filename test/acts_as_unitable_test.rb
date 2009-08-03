require File.dirname(__FILE__) + '/test_helper'

class ActsAsUnitableTest < ActiveSupport::TestCase

  test "accessor gets float with unit" do
    item = Item.create!(:quantity => 5, :quantity_unit => "lbs")
    item.reload
    assert_equal :pounds, item.quantity.unit
  end

  test "writer_sets_qty_and_qty_unit_given_a_string" do
    item = Item.new(:quantity => "5 lbs")
    assert_equal :pounds, item.quantity.unit
    assert_equal "lbs", item.quantity_unit
  end
  
  test "writer_sets_qty_and_qty_unit_given_a_numeric_with_unit" do
    item = Item.new(:quantity => 5.pounds)
    assert_equal :pounds, item.quantity.unit
    assert_equal :pounds, item.quantity_unit
  end
end
