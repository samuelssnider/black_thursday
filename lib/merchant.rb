require 'time'
class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at

  def initialize(data, repo)
    @repo = repo
    @id = data[:id].to_i
    @name = data[:name]
    @created_at = Time.parse(data[:created_at])
    @updated_at = Time.parse(data[:updated_at])
  end

  def items
    @repo.find_all_items(self.id)
  end

  def invoices
    @repo.find_all_invoices(self.id)
  end

  def customers
    invoices.map do |invoice|
      @repo.find_customer(self.id)
    end
  end

end
