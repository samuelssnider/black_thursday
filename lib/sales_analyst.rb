require_relative '../lib/sales_engine'
require_relative '../lib/calculator'
require 'date'
require 'pry'

class SalesAnalyst
  attr_reader :sales_engine
  include Calculator

  def average_invoices_per_merchant
    merchants = @sales_engine.merchants_all.count
    invoices = @sales_engine.invoices_all.count
    (invoices / merchants.to_f).round(2)
  end

  def initialize(sales_engine)
    @sales_engine = sales_engine
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
      day_number =
      day_occurance.merge!({day => invoices.count})
    end
    find_top_days(day_occurance)
  end

  def average_items_per_merchant_standard_deviation
    standard_deviance(all_merchant_averages.map {|average| average[:count]}).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviance(all_invoice_averages).round(2)
  end


  def merchants_with_high_item_count
    s_dev    = average_items_per_merchant_standard_deviation
    avg_each = average_items_per_merchant
    mark     = s_dev + avg_each
    example_merch = []
    example_merch = all_merchant_averages.find_all do |average|
      if average[:count] > mark
        example_merch << average[:merchant].to_s
      end
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
    decimal = result.to_f/total.to_f
    percentage = decimal * 100
    percentage.round(2)
  end


  def average_item_price_for_merchant(id)
    merchant = @sales_engine.merchant_find_by_id(id)
    items = merchant.items
    item_prices = items.map do |item|
      item.unit_price
    end
    mean(item_prices).round(2)
  end

  def average_average_price_per_merchant
    merchants = @sales_engine.merchants.all
    averages = list_avg_merch(merchants)
    mean(averages).round(2)
  end

  def list_avg_merch(in_set)
    in_set.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
  end

  def golden_items
    s_dev = standard_deviance(@sales_engine.items_all.map {|item| item.unit_price})
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
      if invoice.created_at.strftime("%F").eql?(date.strftime("%F"))
        total += invoice.total
      end
    end
    total
  end

  def all_merchant_averages
    repo = @sales_engine.merchants_all
    average_set = []
    repo.each do |merchant|
      average_set << {count: total_matches(merchant.id), merchant: merchant}
    end
    average_set
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

  def merchant_revenue_by_item(merchant_id)
    merchant = @sales_engine.merchant_find_by_id(merchant_id)
    items    = merchant.items
    items.map(Hash.new(0)) do |item|
      ({item.id => item_tot_revenue})
    end
  end


  def most_sold_item_for_merchant(merchant_id) #=> [item] (in terms of quantity sold) or, if there is a tie, [item, item, item]
    merchant = @sales_engine.merchant_find_by_id(merchant_id)
    invoices = merchant.invoices
    invoices_ii = invoices.map do |invoice|
      if invoice.is_paid_in_full?
        invoice.invoice_items.group_by do |invoice_item|
          invoice_item.item_id
        end
      end
    end.compact
    it_id_counts = Hash.new(0)
    invoices_ii.each do |invoice_ii|
      invoice_ii.each_pair do |id, iis|
         it_id_counts.merge!({id => iis.count})
      end
    end
  end


  def best_item_for_merchant(merchant_id) #=> item (in terms of revenue generated)
    all_invoices = @sales_engine.merchant_find_by_id(merchant_id).invoices
    item_revenue = Hash.new(0)
    all_invoices.each do |invoice|
      if invoice.is_paid_in_full?
        invoice.invoice_items.each do |invoice_item|
          hash = {invoice_item.item_id => (invoice_item.unit_price * invoice_item.quantity)}
          item_revenue.merge!(hash)
        end
      end
    end
  end

  def merchants_with_pending_invoices
    not_paid_in_full = @sales_engine.invoices_all.map do |invoice|
      unless invoice.is_paid_in_full?
        invoice.merchant_id
      end
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
      merchant.created_at.strftime("%B") == month
    end
  end

  private

  def sorted_merchants(all_merchant_revenues, list)
    merchants = []
     list.reverse.each do |s|
      all_merchant_revenues.each do |r_m|
        if r_m.keys == s
          merchants << r_m.values
        end
      end
    end
    merchants.flatten
  end

  def convert_date(input) #expected input: invoice object
    Date.parse(input.created_at.to_s).strftime('%A')
  end

  def find_top_days(day_occurance)
    all_averages = day_occurance.values
    s_dev = standard_deviance(all_averages)
    mark = average_invoices_per_day + s_dev
    top_days = []
    day_occurance.each_pair do |day, invoices|
      if invoices > mark
        top_days << day
      end
    end
    top_days
  end

  def average_invoices_per_day
    @sales_engine.invoices_all.count / 7
  end

  def grab(all_merchant_revenues, number = all_merchant_revenues.count)
    revenues = all_merchant_revenues.map do |r|
      r.keys
    end
    sorted   = revenues.sort_by          {|revenue| revenue}
    all      = sorted[(-number)..-1]
    sorted_merchants(all_merchant_revenues, all)
  end

  def merchants_by_revenue(invoice_by_m)
    merchant_revenues = []
    invoice_by_m.each do |helpers|
      total = 0
      helpers.each do |helper|
        total += helper.total
      end
      merchant_revenues << {total => helpers.first.merchant}
    end
    merchant_revenues
  end

  def total_matches(id)
    count = @sales_engine.items_find_all_by_merchant_id(id).count
    count
  end

  def all_invoice_averages
    @sales_engine.merchants_all.map do |merchant|
      merchant.invoices.count
    end
  end

  def invoices_by_merchant
    @sales_engine.merchants_all.map do |merchant|
      merchant.invoices
    end
  end

end
