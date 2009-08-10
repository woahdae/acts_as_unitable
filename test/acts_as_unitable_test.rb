require File.dirname(__FILE__) + '/test_helper'

class ActsAsUnitableTest < ActiveSupport::TestCase

  test "accessor gets float with unit" do
    item = Item.create!(:quantity => 5, :quantity_unit => "lbs")
    item.reload
    assert_equal "lbs", item.quantity_with_unit.units
  end

  test "writer sets qty and qty unit given a string" do
    item = Item.new(:quantity_with_unit => "5 pounds")
    assert_equal 'lbs', item.quantity_with_unit.units
    assert_equal "pounds", item.quantity_unit
  end

  test "writer parses compound fractions with units (ex '1 1/2 cups')" do
    item = Item.new(:quantity_with_unit => "1 1/2 cups")
    assert_equal 1.5, item.quantity_with_unit.scalar
    assert_equal 'cup', item.quantity_with_unit.units
    assert_equal "cups", item.quantity_unit
  end

  test "writer sets qty and qty unit given a numeric with unit" do
    item = Item.new(:quantity_with_unit => 5.to_unit('pounds'))
    assert_equal 'lbs', item.quantity_with_unit.units
    assert_equal 'lbs', item.quantity_unit
  end

end

