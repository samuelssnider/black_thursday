
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




end
