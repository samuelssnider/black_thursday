require 'simplecov'
SimpleCov.start
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require 'pry'
require 'minitest/autorun'
require 'minitest/emoji'

class MerchantTest < Minitest::Test

  def setup
    @merchant = Merchant.new({id: 1,
                              name: "Bob's Bagpipes",
                              created_at: "2010-12-10",
                              updated_at: "2011-12-04"},
                              MerchantRepository.new(self))
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

  def test_items_return
    assert_equal "something", @merchant.items
  end

  # def test_invoices_return
  #   assert_equal "something", @merchant.invoices
  # end
  #
  # def test_customers_return
  #   assert_equal "something", @merchant.customers
  # end


end
