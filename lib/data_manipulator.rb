
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

end
