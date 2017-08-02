require './test/test_helper'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'

class MerchantTest < Minitest::Test

  def setup
    @merchant = Merchant.new({id: 1,
                              name: "Bob's Bagpipes",
                              created_at: "2010-12-10",
                              updated_at: "2011-12-04"},
                              self)
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

end
