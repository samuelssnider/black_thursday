require 'csv'
require_relative '../lib/transaction'

class TransactionRepository

  attr_reader :transactions,
              :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @transactions = []
  end

  def all
    @transactions
  end

  def find_by_id(id)
    @transactions.find {|transaction| transaction.id == id}
  end

  def find_all_by_invoice_id(id)
    @transactions.find_all {|transaction| transaction.invoice_id == id}
  end

  def find_all_by_credit_card_number(cc)
    @transactions.find_all {|transaction| transaction.credit_card_number == cc}
  end

  def find_all_by_result(result)
    @transactions.find_all {|transaction| transaction.result == result}
  end

  def from_csv(path)
    rows = CSV.open path, headers: true, header_converters: :symbol
    rows.each {|data| add_data(data)}
  end

  def add_data(data)
    @transactions << Transaction.new(data.to_hash, self)
  end

  def invoices_find_by_id(id)
    @sales_engine.invoices_find_by_id(id)
  end

  private

    def inspect
      "#<#{self.class} #{@transactions.size} rows>"
    end

end
