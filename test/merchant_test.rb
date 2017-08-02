require './test/test_helper'
require 'pry'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'

class MerchantTest < Minitest::Test

  def setup
    @merchant = Merchant.new({id: 1,
                              name: "Bob's Bagpipes",
                              created_at: "2010-12-10",
                              updated_at: "2011-12-04"},
                              self)
    @se = SalesEngine.from_csv(load_file)
  end

  def test_merchant_exists
    assert_instance_of Merchant, @merchant
  end

  def test_has_id
    assert_equal 1, @merchant.id
  end

  def test_merchant_has_name
    assert_equal "Bob's Bagpipes", @merchant.name
  end

  def test_it_has_created_at_time
    assert_equal Time.parse("2010-12-10"), @merchant.created_at
  end

  def test_it_has_updated_at_time
    assert_equal Time.parse("2011-12-04"), @merchant.updated_at
  end

  def test_merchant_items_return
    assert_equal 10003, @se.merchants.merchants[2].items[0].id
  end

  def test_merchant_invoices_return
    assert_equal [], @se.merchants.merchants[4].invoices
  end

  def test_merchant_customers_return
    assert_equal [], @se.merchants.merchants[4].customers
  end

  def load_file
    {:items=>"./data/items_shorter.csv",
     :merchants=>"./data/merchants_short.csv",
     :customers=>"./data/customers_short.csv",
     :invoices=>"./data/invoices_short.csv",
     :invoice_items=>"./data/invoice_items_short.csv",
     :transactions=>"./data/transactions_short.csv"}
  end

end
