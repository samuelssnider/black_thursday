require 'minitest'
require 'minitest/autorun'
require 'minitets/pride'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test
  def test_it_can_parse
    se = SalesEngine.new
    se.open_csv("./data/merchants_short.csv")
  end
end
