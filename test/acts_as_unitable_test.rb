require File.dirname(__FILE__) + '/test_helper'

class ActsAsUnitableTest < ActiveSupport::TestCase

  test "accessor gets float with unit" do
    item = Item.create!(:quantity => 5, :quantity_unit => "lbs")
    item.reload
    assert_equal "lbs", item.quantity_with_unit.units
  end

  test "writer sets qty and qty unit given a string" do
    item = Item.new(:quantity_with_unit => "5 pounds")
    assert_equal 2.27, item.quantity.round(2)
    assert_equal 5.0, item.quantity_with_unit.scalar
    assert_equal 'lbs', item.quantity_with_unit.units
    assert_equal "pounds", item.quantity_unit
  end

  test "writer parses compound fractions with units" do
    item = Item.new(:quantity_with_unit => "1 1/2 cups")
    assert_equal 1.5, item.quantity_with_unit.scalar.round(1)
    assert_equal 'c', item.quantity_with_unit.units
    assert_equal "cups", item.quantity_unit
  end

  test "writer sets qty and qty unit given a numeric with unit" do
    item = Item.new(:quantity_with_unit => 5.to_unit('pounds'))
    assert_equal 'lbs', item.quantity_with_unit.units
    assert_equal 'lbs', item.quantity_unit
  end
  
  test "does not error on invalid unit; strips unit from accessor instead" do
    item = Item.new(:quantity_with_unit => "5 pxds")
    assert_equal 5.00, item.quantity.round(2)
    assert_equal 5.0, item.quantity_with_unit
    assert_equal true, item.save
  end
  
  test "validates_as_unit adds errors to invalid units" do
    Item.validates_as_unit :quantity
    item = Item.new(:quantity_with_unit => "5 pxds")
    assert_equal false, item.save
    assert_equal "'pxds' is not a valid unit of measurement", item.errors.on("quantity_unit")
  end
end

class ActsAsUnitable::UnitExtensionsTest < ActiveSupport::TestCase
  test "unit_to_fraction_string converts a Unit instance to something like '1 1/2 cups'" do
    unit = (1.5).to_unit('cup')
    assert_equal "1 1/2 c", unit.to_fractional_s
  end
end