require './test/test_helper'
require './lib/invoice_repository'
require './lib/invoice'
require './lib/sales_engine'

class InvoiceTest < Minitest::Test
  def setup
      hash = {id: 2,
              customer_id: 1,
              merchant_id: 12335311,
              status: :Closed,
              created_at: "2012-11-23",
              updated_at: "2013-04-14"}
      @invoice = Invoice.new(hash, 1)
      @se = SalesEngine.from_csv(load_file)
  end

  def test_it_is_initialized_corectly
    data = {id:1}
    i = Invoice.new(data, 1)
    assert i
    assert_instance_of Invoice, i
  end

  def test_initialize_attributes
    assert_equal 2, @invoice.id
    assert_equal 1, @invoice.customer_id
    assert_equal 12335311, @invoice.merchant_id
    assert_equal :Closed, @invoice.status
    assert_equal Time.parse("2012-11-23"), @invoice.created_at
    assert_equal Time.parse("2013-04-14"), @invoice.updated_at
  end

  def test_merchant_return_on_invoices
    assert_nil @se.invoices.invoices[0].merchant
  end

  def test_invoice_items
    assert_equal 1, @se.invoices.invoices[0].invoice_items[0].id
  end

  def test_items_return_on_invoices
    assert_nil @se.invoices.invoices[0].items[0]
  end

  def test_transactions_return_on_invoices
    assert_equal [], @se.invoices.invoices[0].transactions
  end

  def test_customer_return_on_invoices
    assert_equal "Joey", @se.invoices.invoices[0].customer.first_name
  end

  def test_invoice_is_paid_in_full
    refute @se.invoices.invoices[0].is_paid_in_full?
  end

  def test_invoice_total
    assert_equal 0, @se.invoices.invoices[0].total
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
