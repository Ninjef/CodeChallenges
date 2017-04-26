require 'benchmark'
include Benchmark

def highest_product_of_three(list_of_ints)
  highest = [-1.0/0.0,nil]
  second_highest = [-1.0/0.0,nil]
  third_highest = [-1.0/0.0,nil]
  lowest_negative = [0, nil]
  second_lowest_negative = [0, nil]
  list_of_ints.each_with_index do |int, index|
    if int > highest[0]
      third_highest = second_highest
      second_highest = highest
      highest = [int, index]
    elsif int > second_highest[0]
      third_highest = second_highest
      second_highest = [int, index]
    elsif int > third_highest[0]
      third_highest = [int, index]
    end
    if int < 0 && int < lowest_negative[0]
      second_lowest_negative = lowest_negative
      lowest_negative = [int, index]
    elsif int < 0 && int < second_lowest_negative[0]
      second_lowest_negative = [int, index]
    end
  end

  most_negative_ints = [lowest_negative, second_lowest_negative].delete_if {|int| int[0] == 0}
  highest_ints = [highest, second_highest, third_highest]

  best_ints = (most_negative_ints + highest_ints).uniq {|int| int[1]}.map {|int| int[0]}
  sorted_best_ints = best_ints.sort
  best_possible_using_lowest = sorted_best_ints[0] * sorted_best_ints[1] * sorted_best_ints[-1]
  best_possible_using_highest = sorted_best_ints[-1] * sorted_best_ints[-2] * sorted_best_ints[-3]
  best_product_of_three = best_possible_using_highest > best_possible_using_lowest ?  best_possible_using_highest : best_possible_using_lowest
end

def highest_product_of_3(array_of_ints)
    if array_of_ints.length < 3
        raise Exception, 'Less than 3 items!'
    end

    # We're going to start at the 3rd item (at index 2)
    # so pre-populate highests and lowests based on the first 2 items.
    # we could also start these as nil and check below if they're set
    # but this is arguably cleaner
    highest = [array_of_ints[0], array_of_ints[1]].max
    lowest =  [array_of_ints[0], array_of_ints[1]].min

    highest_product_of_2 = array_of_ints[0] * array_of_ints[1]
    lowest_product_of_2  = array_of_ints[0] * array_of_ints[1]

    # except this one--we pre-populate it for the first *3* items.
    # this means in our first pass it'll check against itself, which is fine.
    highest_product_of_3 = array_of_ints[0] * array_of_ints[1] * array_of_ints[2]

    # walk through items, starting at index 2
    # (we could slice the array but that would use n space)
    array_of_ints.each_with_index do |current, index|
        next if index < 2

        # do we have a new highest product of 3?
        # it's either the current highest,
        # or the current times the highest product of two
        # or the current times the lowest product of two
        highest_product_of_3 = [
            highest_product_of_3,
            current * highest_product_of_2,
            current * lowest_product_of_2
        ].max

        # do we have a new highest product of two?
        highest_product_of_2 = [
            highest_product_of_2,
            current * highest,
            current * lowest
        ].max

        # do we have a new lowest product of two?
        lowest_product_of_2 = [
            lowest_product_of_2,
            current * highest,
            current * lowest
        ].min

        # do we have a new highest?
        highest = [highest, current].max

        # do we have a new lowest?
        lowest = [lowest, current].min
    end

    return highest_product_of_3
end

# list_of_ints = [-5,-12,-1,-10,-3,-10,-2,0]
list_of_ints = Array.new(6).map {|int| rand(-999999..999999)}
n = 50000
Benchmark.bm(7, ">speed_improvement:\t") do |x|
  my_method = x.report ("my method:\t") {n.times {highest_product_of_three(list_of_ints)}}
  their_method = x.report ("their method:\t") {n.times {highest_product_of_3(list_of_ints)}}
  [(their_method-my_method)/their_method*100]
end

three = highest_product_of_three(list_of_ints)
three2 = highest_product_of_3(list_of_ints)
puts three
puts three2
puts "diff = #{three - three2}"