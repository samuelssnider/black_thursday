require_relative '../lib/invoice'

class InvoiceRepository

  attr_reader :invoices,
              :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @invoices = []
  end

  def all # - returns an array of all known Invoice instances
    @invoices
  end

  def find_by_id(id) #- returns either nil or an instance of Invoice with a matching ID
    @invoices.find {|i| i.id == id}
  end

  def find_all_by_customer_id(cust_id)
    @invoices.find_all {|i| i.customer_id == cust_id}
  end

  def find_all_by_merchant_id(merch_id) #- returns either [] or one or more matches which have a matching merchant ID
    @invoices.find_all {|i| i.merchant_id == merch_id}
  end

  def find_all_by_status(status) #- returns either [] or one or more matches which have a matching status
    @invoices.find_all {|i| i.status == status}
  end

  def add_data(data)
    @invoices << Invoice.new(data.to_hash, self)
  end

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end

  def merchants_find_by_id(id)
    @sales_engine.merchant_find_by_id(id)
  end

  def invoice_items_find_all_by_invoice_id(id)
    @sales_engine.invoice_items_find_all_by_invoice(id)
  end

  def items_find_by_id(id)
    @sales_engine.item_find_by_id(id)
  end

  def transations_find_all_by_invoice_id(id)
    @sales_engine.transactions_find_all_by_invoice_id(id)
  end

  def customer_find_by_id(id)
        # @sales_engine.customers.find_by_id(self.customer_id)
    @sales_engine.customer_find_by_id(id)
  end



end
