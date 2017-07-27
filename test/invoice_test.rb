require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/invoice'

class InvoiceTest < Minitest::Test
  def setup
    hash = {id: 1, customer_id: 3, merchant_id: 4,
            status: "Closed", created_at: Time.now,
            update_at: Time.now                   }
    @in_v = Invoice.new(hash)
  end

  def test_it_is_initialized_corectly
    data = 1
    i = Invoice.new(data)
    assert i
    assert_instance_of Invoice, i
  end

  def test_own_id_can_be_got
    assert_equal 1, @in_v.id
  end

  def test_customer_id_can_be_got
    assert_equal 3, @in_v.customer_id
  end

  def test_merchant_id_can_be_got
    assert_equal 4, @in_v.merchant_id
  end

  def test_status_can_be_got
    assert_equal "Closed", @in_v.status
  end

  def test_created_at_can_be_got
    assert_equal Time.now, @in_v.created_at
  end

  def test_updated_at_can_be_got
    assert_equal Time.now, @in_v.updated_at
  end





end
