require_relative '../lib/merchant'

class MerchantRepository

  attr_reader :merchants,
              :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @merchants = []
  end

  def all
    @merchants
  end

  def find_by_id(id)
    @merchants.find {|merchant| merchant.id == id}
  end

  def find_by_name(name)
    @merchants.find {|merchant| merchant.name.downcase.include?(name.downcase)}
  end

  def find_all_by_name(name)
    @merchants.find_all {|merchant| merchant.name.downcase.include?(name.downcase)}
  end

  def from_csv(path)
    rows = CSV.open path, headers: true, header_converters: :symbol
    rows.each {|data| add_data(data)}
  end

  def add_data(data)
    @merchants << Merchant.new(data.to_hash, self)
  end

  def find_all_items(id)
    @sales_engine.items_find_all_by_merchant_id(id)
  end

  def find_all_invoices(id)
    @sales_engine.invoices_find_all_by_merchant_id(id)
  end

  def find_customer(id)
    @sales_engine.customer_find_by_id(id)
  end

  private

    def inspect
    "#<#{self.class} #{@merchants.size} rows>"
    end

end
