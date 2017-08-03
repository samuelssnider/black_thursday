
module DataManipulator
  def revenue_by_item(items)
    item_revenues = Hash.new(0)
    items.each do |item|
      item_revenues[item.id] = item_tot_revenue(item.id)
    end
    item_revenues
  end

  def all_merchant_averages(all_merchants)
    average_set = []
    all_merchants.each do |merchant|
      average_set << { count: total_matches(merchant.id), merchant: merchant }
    end
    average_set
  end

  def sorted_merchants(all_merchant_revenues, list)
    merchants = []
    list.reverse.each do |s|
      all_merchant_revenues.each do |r_m|
        merchants << r_m.values if r_m.keys == s
      end
    end
    merchants.flatten
  end

  def list_avg_merch(in_set)
    in_set.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
  end

  def merchants_by_revenue(invoices_by_merchants)
    merchant_revenues = []
    invoices_by_merchants.each do |invoices|
      total = 0
      invoices.each do |invoice|
        total += invoice.total
      end
      merchant_revenues << { total => invoices.first.merchant }
    end
    merchant_revenues
  end

  def convert_date(input) # expected input: invoice object
    Date.parse(input.created_at.to_s).strftime('%A')
  end

  def grab(all_merchant_revenues, number = all_merchant_revenues.count)
    revenues = all_merchant_revenues.map(&:keys)
    if number > revenues.count
      sorted   = revenues.sort
      all      = sorted
      sorted_merchants(all_merchant_revenues, all)
    else
      sorted   = revenues.sort
      all      = sorted[-number..-1]
      sorted_merchants(all_merchant_revenues, all)
    end
  end

  def find_top_days(day_occurance)
    all_averages = day_occurance.values
    s_dev = standard_deviance(all_averages)
    mark = average_invoices_per_day + s_dev
    top_days = []
    day_occurance.each_pair do |day, invoices|
      top_days << day if invoices > mark
    end
    top_days
  end

end
