require 'benchmark'

def get_products_of_all_ints_except_at_index1(integers)
  integers.each_with_index.map do |integer, index|
    other_integers = Array.new(integers)
    other_integers.delete_at(index)
    other_integers.reduce {|total, other_integer| total *= other_integer}
  end
end

def get_products_of_all_ints_except_at_index2(integers)
  if integers.length < 2
    raise IndexError, 'Can\'t perform this method on arrays with only one element'
  end

  product_of_ints_before_index = []
  product_before = 1
  i = 0
  while i < integers.length
    product_of_ints_before_index[i] = product_before
    product_before *= integers[i]
    i += 1
  end
  # => product_of_ints_before_index = [1, 1, 2, 12, 60]

  answer = Array.new(integers.length)
  product_after = 1
  i = integers.length - 1
  while i >= 0
    answer[i] = product_after * product_of_ints_before_index[i]
    product_after *= integers[i]
    i -= 1
  end
  return answer
end

[5,8,3,1,7]

[7,1,3,8,5]
[7*1, 7*1*3*5, 7*]


[1, 5, 5*8, 5*8*3, 5*8*3*1]
[1, 7, 7*1, 7*1*3, 7*1*3*8]

1st pass: All previous integers multiplied by 1, and all  multiplier is 8*3*1*7
2nd pass: All previous integers multiplied by 5, and current multiplier is 3*1*7
3rd pass: All previous integers multiplied by 5*8, and current multiplier is 1*7
4th pass: All previous integers multiplied by 5*8*3, and current multiplier is 7
5th pass: All previous integers multiplied by 5*8*3*1, and there is no current multiplier