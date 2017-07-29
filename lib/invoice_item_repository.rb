require_relative '../lib/invoice_item'
require 'pry'
class InvoiceItemRepository

  attr_reader :invoice_items

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @invoice_items = []
  end

  def all
    @invoice_items
  end

  def find_by_id(id)
    @invoice_items.find do |ii|
      ii.id == id
    end
  end

  def find_all_by_item_id(item_id)
    results = []
    @invoice_items.each do |ii|
      if ii.item_id == item_id
        results << ii
      end
    end
    results
  end

  def find_all_by_invoice_id(invoice_id)
    results = []
    @invoice_items.each do |ii|
      if ii.invoice_id == invoice_id
        results << ii
      end
    end
    results
  end

  def from_csv(path)
    rows = CSV.open path, headers: true, header_converters: :symbol
    rows.each do |data|
      add_data(data)
    end
  end

  def add_data(data)
    @invoice_items << InvoiceItem.new(data.to_hash, @sales_engine)
  end

  def inspect
    "#<#{self.class} #{@invoice_items.size} rows>"
  end

end