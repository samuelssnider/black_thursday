require_relative '../lib/sales_engine'
require_relative '../lib/calculator'
require 'pry'

class SalesAnalyst
  attr_reader :sales_engine
  include Calculator

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    merchants = @sales_engine.merchants.all.count
    items = @sales_engine.items.all.count
    (items / merchants.to_f).round(2)
  end

  def average_invoices_per_merchant
    merchants = @sales_engine.merchants.all.count
    invoices = @sales_engine.invoices.all.count
    (invoices / merchants.to_f).round(2)
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
    mark = s_dev + avg_each
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
    @sales_engine.merchants.all.find_all do |merchant|
      merchant.invoices.count > (average_invoices_per_merchant + average_invoices_per_merchant_standard_deviation * 2)
    end
  end



  def average_item_price_for_merchant(id)
    merchant = @sales_engine.merchants.find_by_id(id)
    items = merchant.items
    item_prices = items.map do |item|
      item.unit_price
    end
    # binding.pry
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
    s_dev = standard_deviance(@sales_engine.items.items.map {|item| item.unit_price})
    avg_each = average_average_price_per_merchant
    mark = avg_each + (s_dev * 2)
    golden_set = @sales_engine.items.items.find_all do |item|
      item.unit_price > mark
    end
    items = golden_set.map do |golden|
      golden
    end
    items
  end

  # def all_averages(repo)
  #   binding.pry
  #   repo = @sales_engine.method(repo.to_sym).all
  #   binding.pry
  #   average_set = []
  #   repo.each do |instance|
  #     average_set << ({count: total_matches(instance.id), repo.to_sym instance})
  #   end
  # end

  def all_merchant_averages
    repo = @sales_engine.merchants.all
    average_set = []
    repo.each do |merchant|
      average_set << {count: total_matches(merchant.id), merchant: merchant}
    end
    average_set
  end

  def all_invoice_averages
    @sales_engine.merchants.all.map do |merchant|
      merchant.invoices.count
    end
  end

  def average(data_set)
    sum = 0
    data_set.each do |average|
      sum += average[:count]
    end
    average = (sum/data_set.count.to_f)
    average.round(2)
  end

  def total_matches(id)
    count = @sales_engine.items.find_all_by_merchant_id(id).count
    count
  end


end
