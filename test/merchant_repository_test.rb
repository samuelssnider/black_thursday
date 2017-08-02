require './test/test_helper'
require './lib/merchant_repository'
require 'csv'
require_relative '../lib/sales_engine'

class MerchantRepositoryTest < Minitest::Test

  def setup
    # @merchant_r = MerchantRepository.new(self)

    hash_one   = {id:1, name: "Target", created_at: "2010-01-01", updated_at: "2011-01-01"}
    hash_two   = {id:2, name: "Walmart", created_at: "2010-02-02", updated_at: "2011-02-02"}
    hash_three = {id:3, name: "CostMart", created_at: "2010-03-03", updated_at: "2011-03-03"}
    hash_four  = {id:4, name: "Costco", created_at: "2010-04-04", updated_at: "2011-04-04"}
    @merchant_r = MerchantRepository.new(self)
    @merchant_r.add_data(hash_one)
    @merchant_r.add_data(hash_two)
    @merchant_r.add_data(hash_three)
    @merchant_r.add_data(hash_four)

    hash = {
            :items         => "./data/sa/items_sa.csv",
            :merchants     => "./data/sa/merchants_sa.csv",
            :invoices      => "./data/sa/invoices_sa.csv",
            :invoice_items => "./data/sa/invoice_items_sa.csv",
            :customers     => "./data/sa/customers_sa.csv",
            :transactions  => "./data/sa/transactions_sa.csv"}
    @se_short= SalesEngine.from_csv(hash)
  end


  def test_it_can_be_initialized
    mr = MerchantRepository.new(self)
    assert mr
    assert_instance_of MerchantRepository, mr
    assert mr.merchants.empty?
  end

  def test_all_is_working
    list = @merchant_r.merchants
    assert_equal 4, list.count
    assert_equal 1, list.first.id
    assert_equal 4, list.last.id
  end

  def test_find_by_id_is_working
    found = @merchant_r.find_by_id(3)
    assert_equal 3, found.id
    assert_equal "CostMart", found.name
  end

  def test_find_by_name_is_working
    found = @merchant_r.find_by_name("Walmart")
    assert_equal 2, found.id
    assert_equal "Walmart", found.name
  end

  def test_find_all_by_name_is_working_for_one_entry
    list = @merchant_r.find_all_by_name("Walmart")
    assert_equal 1, list.count
    assert_equal 2, list.first.id
  end

  def test_find_all_is_working_for_just_part_of_the_name
    list = @merchant_r.find_all_by_name("lma")
    assert_equal 1, list.count
    assert_equal 2, list.first.id
  end

  def test_find_all_by_name_is_working_for_multiple_entries
    list = @merchant_r.find_all_by_name("mart")
    assert_equal 2, list.count
    assert_equal 2, list.first.id
    assert_equal 3, list.last.id
    list_two = @merchant_r.find_all_by_name("t")
    assert_equal 4, list_two.count
  end

  def test_adding_data_by_csv
    merchant = MerchantRepository.new(self)
    merchant.from_csv("./data/merchants_short.csv")
    assert_equal 5, merchant.all.count
  end

  def test_find_customer
    customers = @se_short.merchants_all.first.customers
    assert_equal 3, customers.count
    assert_instance_of Customer, customers.first
    assert_instance_of Customer, customers.last

  end

end
