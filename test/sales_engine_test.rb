require './test/test_helper'
require_relative '../lib/sales_engine'
require 'csv'
require 'pry'

class SalesEngineTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv(load_file)
  end

  def test_it_can_be_initialized
    assert_instance_of SalesEngine, @se
  end

  def test_initialize_attributes
    assert_instance_of ItemRepository, @se.items
    assert_instance_of MerchantRepository, @se.merchants
    assert_instance_of InvoiceRepository, @se.invoices
    assert_instance_of TransactionRepository, @se.transactions
    assert_instance_of InvoiceItemRepository, @se.invoice_items
    assert_instance_of CustomerRepository, @se.customers
  end

  def test_merchants_all
    assert_equal 5, @se.merchants_all.count
  end

  def test_merchant_find_by_id
    assert_equal "LolaMarleys", @se.merchant_find_by_id(12334115).name
  end

  def test_merchant_find_by_name
    assert_equal 12334115, @se.merchant_find_by_name("LolaMarleys").id
  end

  def test_merchants_find_all_by_name
    assert_equal 2, @se.merchants_find_all_by_name("ar").count
  end

  def test_items_all
    assert_equal 3, @se.items_all.count
  end

  def test_item_find_by_id
    assert_equal "Item 5", @se.item_find_by_id(10004).name
  end

  def test_item_find_by_name
    assert_equal 10003, @se.item_find_by_name("Item 4").id
  end

  def test_items_find_all_with_description
    assert_equal 2, @se.items_find_all_with_description("ano").count
  end

  def test_items_find_all_by_price
    assert_equal "Item 4", @se.items_find_all_by_price(BigDecimal.new(12.5, 4))[0].name
  end

  def test_items_find_all_by_price_in_range
    range = (BigDecimal.new(6.5, 4)..BigDecimal.new(12.5, 4))
    assert_equal 2, @se.items_find_all_by_price_in_range(range).count
  end

  def test_items_find_all_by_merchant_id
    assert_equal 2, @se.items_find_all_by_merchant_id(12334113).count
  end

  def test_invoices_all
    assert_equal 10, @se.invoices_all.count
  end

  def test_invoices_find_by_id
    assert_equal 1, @se.invoices_find_by_id(3).customer_id
  end

  def test_invoices_find_all_by_customer_id
    assert_equal 8, @se.invoices_find_all_by_customer_id(1).count
  end

  def test_invoices_find_all_by_merchant_id
    assert_equal 2, @se.invoices_find_all_by_merchant_id(12334269).count
  end

  def test_invoices_find_all_by_status
    assert_equal 6, @se.invoices_find_all_by_status("pending".to_sym).count
  end

  def test_invoice_items_all
    assert_equal 10, @se.invoice_items_all.count
  end

  def test_invoice_item_find_by_id
    assert_equal 4, @se.invoice_item_find_by_id(9).invoice_id
  end

  def test_invoice_items_find_all_by_item_id
    assert_equal 2, @se.invoice_items_find_all_by_item_id(123400005).count
  end

  def test_invoice_items_find_all_by_invoice
    assert_equal 3, @se.invoice_items_find_all_by_invoice(3).count
  end

  def test_transactions_all
    assert_equal 10, @se.transactions_all.count
  end

  def test_transaction_find_by_id
    assert_equal 3333, @se.transaction_find_by_id(3).invoice_id
  end

  def test_transactions_find_all_by_invoice_id
    assert_equal 2, @se.transactions_find_all_by_invoice_id(8888).count
  end

  def test_transactions_find_all_by_credit_card_number
    actual = @se.transactions_find_all_by_credit_card_number(4839506591130408)
    assert_equal 2, actual.count
  end

  def test_transactions_find_all_by_result
    assert_equal 6, @se.transactions_find_all_by_result("success").count
  end

  def test_customers_all
    assert_equal 10, @se.customers_all.count
  end

  def test_customer_find_by_id
    assert_equal "Cecelia", @se.customer_find_by_id(2).first_name
  end

  def test_customers_find_all_by_first_name
    assert_equal 7, @se.customers_find_all_by_first_name("e").count
  end

  def test_customers_find_all_by_last_name
    assert_equal 5, @se.customers_find_all_by_last_name("a").count
  end
#=======================

  # def test_class_method_working
  #   se = SalesEngine.from_csv({
  #                             :items     => "./data/items.csv",
  #                             :merchants => "./data/merchants.csv",
  #                                                                 })
  #   assert_instance_of SalesEngine, se
  #   assert se
  # end
  #
  # def test_class_method_integration_merch_repo
  #   found_1    = @se.merchants.find_by_name("MyouBijou")
  #   found_2    = @se.merchants.find_by_id(12335252)
  #   found_list_one = @se.merchants.find_all_by_name("liv")
  #   found_list_two = @se.merchants.find_all_by_name("ba")
  #   assert_equal "MyouBijou"  , found_1.name
  #   assert_equal 12334455     , found_1.id
  #   assert_equal "habichschon", found_2.name
  #   assert_equal 12335252     , found_2.id
  #   assert_equal 4            , found_list_one.count
  #   assert_equal 15           , found_list_two.count
  # end
  #
  #
  # def test_class_method_integration_item_repo
  #   found_1    = @se.items.find_by_name("510+ RealPush Icon Set")
  #   found_2    = @se.items.find_by_id(263396013)
  #
  #   assert_equal "510+ RealPush Icon Set"     , found_1.name
  #   assert_equal 263395237                    , found_1.id
  #   assert_equal "Free standing Woden letters", found_2.name
  #   assert_equal 263396013                    , found_2.id
  # end
  #
  # def test_find_all_with_descrip_or_merch_id_work_integration
  #   found_list_one = @se.items.find_all_with_description("liv")
  #   found_list_two = @se.items.find_all_by_merchant_id(12334185)
  #
  #   assert_equal 94, found_list_one.count
  #   assert_equal 6, found_list_two.count
  # end
  #
  # def test_find_all_by_price_and_price_range_integration
  #   found_list_one = @se.items.find_all_by_price(700)
  #   found_list_two = @se.items.find_all_by_price_in_range(500..600)
  #
  #   assert_equal 2, found_list_one.count
  #   assert_equal 27, found_list_two.count
  # end

  def load_file
    {:items=>"./data/items_shorter.csv",
     :merchants=>"./data/merchants_short.csv",
     :customers=>"./data/customers_short.csv",
     :invoices=>"./data/invoices_short.csv",
     :invoice_items=>"./data/invoice_items_short.csv",
     :transactions=>"./data/transactions_short.csv"}
  end

end
