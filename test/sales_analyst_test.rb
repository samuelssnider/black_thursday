require './test/test_helper'
require_relative '../lib/sales_analyst'
require 'time'

class SalesAnalystTest < Minitest::Test
  def setup
    # @se = SalesEngine.from_csv({
    #                           :items     => "./data/items.csv",
    #                           :merchants => "./data/merchants.csv",
    #                           :invoices  => "./data/invoices.csv"})
    # @sa = SalesAnalyst.new(@se)
    hash = {
            :items         => "./data/sa/items_sa.csv",
            :merchants     => "./data/sa/merchants_sa.csv",
            :invoices      => "./data/sa/invoices_sa.csv",
            :invoice_items => "./data/sa/invoice_items_sa.csv",
            :customers     => "./data/sa/customers_sa.csv",
            :transactions  => "./data/sa/transactions_sa.csv"}
    @se_short= SalesEngine.from_csv(hash)
    @sa_short = SalesAnalyst.new(@se_short)

  end

  def test_it_can_be_initialized
    sa = SalesAnalyst.new(SalesEngine.new(0))
    assert_instance_of SalesAnalyst, sa
    assert sa
  end

  def test_average_invoices_per_merchant
    assert_equal 2.33, @sa_short.average_invoices_per_merchant
  end

  def test_average_items_per_merchant
    assert_equal 1.67, @sa_short.average_items_per_merchant
  end

  def test_top_days_by_invoice_count
    assert_equal ["Monday"], @sa_short.top_days_by_invoice_count
  end

  def test_average_items_per_merchant_standard_deviation
    assert_equal 1.16, @sa_short.average_items_per_merchant_standard_deviation
  end

  def test_average_invoices_per_merchant_standard_deviation
    assert_equal 1.16, @sa_short.average_invoices_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count
    assert_equal [@se_short.merchant_find_by_id(12334105)], @sa_short.merchants_with_high_item_count
  end

  def test_top_merchants_by_invoice_count
    assert @sa_short.top_merchants_by_invoice_count.empty?
  end

  def test_bottom_merchants_by_invoice_count
    assert @sa_short.bottom_merchants_by_invoice_count.empty?
  end

  def test_invoice_status
    assert_equal 28.57, @sa_short.invoice_status(:pending)
    assert_equal 42.86, @sa_short.invoice_status(:shipped)
    assert_equal 28.57, @sa_short.invoice_status(:returned)
  end

  def test_average_item_price_for_merchant
    assert_equal 16.66, @sa_short.average_item_price_for_merchant(12334105)
    assert_equal 15, @sa_short.average_item_price_for_merchant(12334112)
    assert_equal 150, @sa_short.average_item_price_for_merchant(12334113)
  end

  def test_average_average_price_per_merchant
    assert_equal 60.55, @sa_short.average_average_price_per_merchant
  end

  def test_golden_items
    assert @sa_short.golden_items.empty?
  end

  def test_total_revenue_by_date
    assert_equal 13410.5, @sa_short.total_revenue_by_date(Time.parse("2003-04-07"))
    assert_equal 4380.14, @sa_short.total_revenue_by_date(Time.parse("2005-01-03"))
    assert_equal 4647.1, @sa_short.total_revenue_by_date(Time.parse("2015-08-21"))
    assert_equal 0.0, @sa_short.total_revenue_by_date(Time.parse("2010-09-14"))
  end

  def test_top_revenue_earners
    assert_equal @se_short.merchants_all.count, @sa_short.top_revenue_earners.count
    assert_equal @sa_short.merchants_ranked_by_revenue, @sa_short.top_revenue_earners

  end

  def test_merchants_ranked_by_revenue
    assert_equal @se_short.merchants_all.count, @sa_short.merchants_ranked_by_revenue.count
    assert_equal @sa_short.top_revenue_earners,  @sa_short.merchants_ranked_by_revenue
  end

  def test_merchants_with_pending_invoices
    assert_equal 2, @sa_short.merchants_with_pending_invoices.count
  end

  def test_merchants_with_only_one_item
    array = [@se_short.merchant_find_by_id(12334112),@se_short.merchant_find_by_id(12334113)]
    assert_equal array, @sa_short.merchants_with_only_one_item
  end

  def test_merchants_with_only_one_item_registered_in_month
    assert_equal [], @sa_short.merchants_with_only_one_item_registered_in_month("January")
    assert_equal [@se_short.merchant_find_by_id(12334112)], @sa_short.merchants_with_only_one_item_registered_in_month("May")
    assert_equal [], @sa_short.merchants_with_only_one_item_registered_in_month("June")
    assert_equal [@se_short.merchant_find_by_id(12334113)], @sa_short.merchants_with_only_one_item_registered_in_month("March")
  end








end

#   def test_it_can_do_average
#     assert_equal 2.88, @sa.average_items_per_merchant
#   end
#
#   def test_it_can_do_standard_dev
#     assert_equal 3.26, @sa.average_items_per_merchant_standard_deviation
#   end
#
#   def test_it_can_do_average_item_price_for_merchant
#     assert_equal 130, @sa.average_item_price_for_merchant(12335227)
#   end
#
#   def test_it_can_average_averages
#     # assert_equal 10, @sa.average_average_price_per_merchant
#     # assert_equal 1445, @sa_short.average_average_price_per_merchant
#     assert_equal 350.29, @sa.average_average_price_per_merchant
#     # assert_equal 1445, @sa_short.average_average_price_per_merchant
#   end
#
#   def test_it_returns_golden_items
#     assert_instance_of Array, @sa.golden_items
#     assert_equal 5, @sa.golden_items.count
#     assert_equal 5, @sa.sales_engine.items.find_all_by_price_in_range(6152..10000000000).count
#   end
# end
