require 'pry'
module Calculator

  def sum(array)
    array.reduce(:+)
  end

  def mean(array)
    sum(array) / array.count.to_f
  end

  def difference(array)
    array.map {|i| (i - mean(array)) ** 2}
  end

  def standard_deviance(array)
    difference_array = difference(array)
    total_difference = sum(difference_array)
    average_difference = total_difference / (array.count - 1)
    Math.sqrt(average_difference).round(3)
  end

  def average_this_per_that(this, that)
    (this / that.to_f).round(2)
  end

end
