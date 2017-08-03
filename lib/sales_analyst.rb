require_relative '../lib/sales_engine'
require_relative '../lib/calculator'
require 'date'
require 'pry'
require_relative '../lib/data_manipulator'

class SalesAnalyst
  attr_reader :sales_engine
  include Calculator
  include DataManipulator

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_invoices_per_merchant
    merchants = @sales_engine.merchants_all.count
    invoices = @sales_engine.invoices_all.count
    (invoices / merchants.to_f).round(2)
  end

  def average_items_per_merchant
    merchants = @sales_engine.merchants_all.count
    items = @sales_engine.items_all.count
    (items / merchants.to_f).round(2)
  end

  def top_days_by_invoice_count
    results = @sales_engine.invoices.all.group_by do |invoice|
      convert_date(invoice)
    end
    day_occurance = {}
    results.each_pair do |day, invoices|
      day_occurance.merge!(day => invoices.count)
    end
    find_top_days(day_occurance)
  end

  def average_items_per_merchant_standard_deviation
    standard_deviance(all_merchant_averages(sales_engine.merchants_all).map { |average| average[:count] }).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviance(all_invoice_averages).round(2)
  end

  def merchants_with_high_item_count
    s_dev         = average_items_per_merchant_standard_deviation
    avg_each      = average_items_per_merchant
    mark          = s_dev + avg_each
    example_merch = []
    example_merch = all_merchant_averages(sales_engine.merchants_all).find_all do |average|
      example_merch << average[:merchant].to_s if average[:count] > mark
    end
    examples = example_merch.map do |example|
      example[:merchant]
    end
    examples
  end

  def top_merchants_by_invoice_count
    mark = (average_invoices_per_merchant + average_invoices_per_merchant_standard_deviation * 2)
    @sales_engine.merchants_all.find_all do |merchant|
      merchant.invoices.count > mark
    end
  end

  def bottom_merchants_by_invoice_count
    mark = (average_invoices_per_merchant - average_invoices_per_merchant_standard_deviation * 2)
    @sales_engine.merchants_all.find_all do |merchant|
      merchant.invoices.count < mark
    end
  end

  def invoice_status(symbol)
    total = @sales_engine.invoices_all.count
    case symbol
    when :pending
      result = @sales_engine.invoices_all.count do |invoice|
        invoice.status == :pending
      end
    when :shipped
      result = @sales_engine.invoices_all.count do |invoice|
        invoice.status == :shipped
      end
    when :returned
      result = @sales_engine.invoices_all.count do |invoice|
        invoice.status == :returned
      end
    end
    decimal = result.to_f / total.to_f
    percentage = decimal * 100
    percentage.round(2)
  end

  def average_item_price_for_merchant(id)
    merchant = @sales_engine.merchant_find_by_id(id)
    items = merchant.items
    item_prices = items.map(&:unit_price)
    mean(item_prices).round(2)
  end

  def average_average_price_per_merchant
    merchants = @sales_engine.merchants.all
    averages = list_avg_merch(merchants)
    mean(averages).round(2)
  end

  def golden_items
    s_dev = standard_deviance(@sales_engine.items_all.map(&:unit_price))
    avg_each = average_average_price_per_merchant
    mark = avg_each + (s_dev * 2)
    golden_set = @sales_engine.items_all.find_all do |item|
      item.unit_price > mark
    end
    items = golden_set.map do |golden|
      golden
    end
    items
  end

  def total_revenue_by_date(date)
    total = 0.0
    @sales_engine.invoices_all.each do |invoice|
      if invoice.created_at.strftime('%F').eql?(date.strftime('%F'))
        total += invoice.total
      end
    end
    total
  end

  def top_revenue_earners(number = 20)
    grab(merchants_by_revenue(invoices_by_merchant), number)
  end

  def merchants_ranked_by_revenue
    grab(merchants_by_revenue(invoices_by_merchant))
  end

  def revenue_by_merchant(merchant_id)
    merchants_by_revenue(invoices_by_merchant).find do |rev_merch|
      rev_merch.values.first.id == merchant_id
    end.keys.first
  end

  def revenue_by_merchant(merchant_id)
    merchants_by_revenue(invoices_by_merchant).find do |rev_merch|
      rev_merch.values.first.id == merchant_id
    end.keys.first
  end

  def most_sold_item_for_merchant(merchant_id) #=> [item] (in terms of quantity sold) or, if there is a tie, [item, item, item]
    merchant = @sales_engine.merchant_find_by_id(merchant_id)
    results = Hash.new(0)
    reply = []
    merchant.invoices.each do |invoice|
      next unless invoice.is_paid_in_full?
      invoice.invoice_items.each do |item|
        results[item.item_id] += item.quantity
      end
    end
    max = results.max_by { |_k, v| v }[1]
    results.each_pair do |k, v|
      reply << @sales_engine.item_find_by_id(k) if v == max
    end
    reply
  end

  def best_item_for_merchant(merchant_id)
    merchant = @sales_engine.merchant_find_by_id(merchant_id)
    results = Hash.new(0)
    merchant.invoices.each do |invoice|
      next unless invoice.is_paid_in_full?
      invoice.invoice_items.each do |item|
        results[item.item_id] += (item.quantity * item.unit_price.to_f)
      end
    end
    top = results.key(results.values.max)
    @sales_engine.item_find_by_id(top)
  end

  def merchants_with_pending_invoices
    not_paid_in_full = @sales_engine.invoices_all.map do |invoice|
      invoice.merchant_id unless invoice.is_paid_in_full?
    end.compact
    not_paid_in_full.map do |not_paid|
      @sales_engine.merchant_find_by_id(not_paid)
    end.uniq
  end

  def merchants_with_only_one_item
    @sales_engine.merchants_all.find_all do |merchant|
      merchant.items.count == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_with_only_one_item.find_all do |merchant|
      merchant.created_at.strftime('%B') == month
    end
  end

  private

  def average_invoices_per_day
    @sales_engine.invoices_all.count / 7
  end

  def total_matches(id)
    count = @sales_engine.items_find_all_by_merchant_id(id).count
  end

  def all_invoice_averages
    @sales_engine.merchants_all.map do |merchant|
      merchant.invoices.count
    end
  end

  def invoices_by_merchant
    @sales_engine.merchants_all.map(&:invoices)
  end
  
end
