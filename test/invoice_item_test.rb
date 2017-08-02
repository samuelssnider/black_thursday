require './test/test_helper'
require './lib/invoice_item'

class InvoiceItemTest < Minitest::Test

  def setup
    hash = {id: 1, item_id: 3, invoice_id: 4,
            quantity: 41, unit_price: 1200,
            created_at: "2012-11-23", updated_at: "2013-04-14"}
    @in_item = InvoiceItem.new(hash, self)
  end

  def test_it_exists
    assert_instance_of InvoiceItem, @in_item
  end

  def test_it_has_id
    assert_equal 1, @in_item.id
  end

  def test_it_has_item_id
    assert_equal 3, @in_item.item_id
  end

  def test_it_has_invoice_id
    assert_equal 4, @in_item.invoice_id
  end

  def test_it_has_quantity
    assert_equal 41, @in_item.quantity
  end

  def test_it_has_unit_price
    assert_equal 12, @in_item.unit_price.to_i
  end

  def test_it_has_created_at_time
    assert_equal Time.parse("2012-11-23"), @in_item.created_at
  end

  def test_it_has_updated_at_time
    assert_equal Time.parse("2013-04-14"), @in_item.updated_at
  end

end
