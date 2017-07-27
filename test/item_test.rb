require 'minitest'
require 'minitest/autorun'
require 'minitest/emoji'
require_relative '../lib/item'
require 'bigdecimal'
require 'time'


class ItemTest < Minitest::Test

  def setup
    hash = {id: 1,
            name: "Candy",
            description: "yellow",
            unit_price: 120,
            merchant_id: 13,
            created_at: "2016-01-11 11:51:37 UTC",
            updated_at: "2016-01-11 11:51:37 UTC"
           }
    @the_item = Item.new(hash, self)
  end

  def test_it_has_id
    assert_equal 1, @the_item.id
  end

  def test_it_has_name
    assert_equal "Candy", @the_item.name
  end

  def test_it_has_descriptions
    assert_equal "yellow", @the_item.description
  end

  def test_it_has_unit_price
    assert_equal 1.2, @the_item.dollars
  end

  def test_it_has_merchant_id
    assert_equal 13, @the_item.merchant_id
  end

  def test_it_has_created_at
    assert_instance_of Time, @the_item.created_at
  end

  def test_it_has_updated_at
    assert_instance_of Time, @the_item.updated_at
  end

  def test_it_is_initialized_corretly
    assert_instance_of Item, @the_item
  end

  # def test_spec_creation
  #   item = Item.new({:name        => "Pencil",
  #                    :description => "You can use it to write things",
  #                    :unit_price  => BigDecimal.new(10.99,4),
  #                    :created_at  => Time.now,
  #                    :updated_at  => Time.now
  #                   })
  #   new_item = Item.new(item, self)
  #   assert_instance_of Item, new_item
  # end

end
