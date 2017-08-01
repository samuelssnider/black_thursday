require 'csv'
require 'pry'
require 'time'
require_relative './item_repository'
require_relative './merchant_repository'
require_relative './invoice_repository'
require_relative './transaction_repository'
require_relative './invoice_item_repository'
require_relative './customer_repository'

class SalesEngine

  attr_reader :merchants,
              :items,
              :invoices,
              :transactions,
              :invoice_items,
              :customers

  def initialize(data)
    @items         = ItemRepository.new(self)
    @merchants     = MerchantRepository.new(self)
    @invoices      = InvoiceRepository.new(self)
    @transactions  = TransactionRepository.new(self)
    @invoice_items = InvoiceItemRepository.new(self)
    @customers     = CustomerRepository.new(self)
  end

  def self.from_csv(input)
    created = SalesEngine.new(input)
    input.each_pair do |key, value|
      row = CSV.open value, headers: true, header_converters: :symbol
      row.each do |data|
        created.send(key).add_data(data.to_hash)
      end
    end
    created
  end

  def merchants_all
    @merchants.all
  end

  def merchant_find_by_id(id)
    @merchants.find_by_id(id)
  end

  def merchant_find_by_name(name)
    @merchants.find_by_name(name)
  end

  def merchants_find_all_by_name(name)
    @merchants.find_all_by_name(name)
  end

  def items_all
    @items.all
  end

  def item_find_by_id(id)
    @items.find_by_id(id)
  end

  def item_find_by_name(name)
    @items.find_by_name
  end

  def items_find_all_with_description(description)
    @items.find_all_with_description(description)
  end

  def items_find_all_by_price
    @items.find_all_by_price(price)
  end

  def items_find_all_by_price_in_range(range)
    @items.find_all_by_price_in_range(range)
  end

  def items_find_all_by_merchant_id(id)
    @items.find_all_by_merchant_id(id)
  end

  def invoices_all
    @invoices.all
  end

  def invoice_find_by_id(id)
    @invoices.find_by_id(id)
  end

  def invoices_find_all_by_customer_id(cust_id)
    @invoices.find_all_by_customer_id(cust_id)
  end

  def invoices_find_all_by_merchant_id(merch_id)
    @invoices.find_all_by_merchant_id(merch_id)
  end

  def invoices_find_all_by_status(status)
    @invoices.find_all_by_status(status)
  end

  def invoice_items_all
    @invoice_items.all
  end

  def invoice_item_find_by_id(id)
    @invoice_items.find_by_id(id)
  end

  def invoice_items_find_all_by_item_id(item_id)
    @invoice_items.find_all_by_item_id(item_id)
  end

  def invoice_items_find_all_by_invoice(invoice_id)
    @invoice_items.find_all_by_invoice_id(invoice_id)
  end

  def transactions_all
    @transactions.all
  end

  def transaction_find_by_id(id)
    @transactions.find_by_id(id)
  end

  def transactions_find_all_by_invoice_id(invoice_id)
    @transactions.find_all_by_invoice_id(invoice_id)
  end

  def transactions_find_all_by_credit_card_number(cc)
    @transactions.find_all_by_credit_card_number
  end

  def transactions_find_all_by_result(result)
    @transactions.find_all_by_result(result)
  end

  def customers_all
    @customers.all
  end

  def customer_find_by_id(id)
    binding.pry
    @customers.find_by_id(id)
  end

  def customers_find_all_by_first_name(f_name)
    @customers.find_all_by_first_name(f_name)
  end

  def customers_find_all_by_last_name(l_name)
    @customers.find_all_by_last_name(l_name)
  end



end
