require 'bigdecimal'
class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :merchant_id,
              :created_at,
              :updated_at,
              :dollars

  def initialize(data, item_repo)
    @repo = item_repo
    @id = data[:id].to_i
    @name = data[:name]
    @description = data[:description]
    @unit_price = BigDecimal.new(data[:unit_price],4) / 100
    @dollars = @unit_price.to_f
    @merchant_id = data[:merchant_id].to_i
    @created_at = Time.parse(data[:created_at])
    @updated_at = Time.parse(data[:updated_at])
  end

  def merchant
    @repo.find_merchant_by_id(merchant_id)
  end

end
