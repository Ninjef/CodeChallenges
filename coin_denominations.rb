require 'pry'
require 'benchmark'

# So it looks like we're iterating through each denomination. Within each denomination, we're adding
#  a multiplier, starting at 0, to all of the other denominations and testing if that works.
# A. Then we increase the muiltiplier by one for the next denomination. If the multiplied denominations
#  plus the main denomination is less than the total amount, we test that combination, and go through 
#  A again for the next denomination. Else we go back to the last increased denomination and incrase it again
#  until it fails.

def reset_multiplier(multipliers, position)
  multipliers[position][:multiplier] = 0
end

def increase_multiplier(multipliers, position)
  multipliers[position][:multiplier] += 1
end

def combine_multipliers(multipliers)
  multipliers.reduce(0) {|total, multiplier| total += multiplier[:denomination] * multiplier[:multiplier]}
end

def goes_into?(amount, denomination)
  (amount / denomination) % 1 == 0
end

def valid_combinations_1(total_amount, denominations)
  iterations = denominations.length
  valid_combinations = 0
  i = 0
  while i < iterations
    divisor = denominations.shift
    multipliers = denominations.map {|denomination| {denomination: denomination, multiplier: 0}}

    if divisor <= total_amount
      valid_combinations += 1 if (total_amount.to_f / divisor.to_f) % 1 == 0
      j = 0
      while j < multipliers.length
        # multipliers[j][:multiplier] += 1
        valid_combinations += increment(total_amount, multipliers, j, divisor)
        j += 1
      end
    end
    i += 1
  end
  return valid_combinations
end

def increment(total_amount, multipliers, i, divisor)
  valid_combinations = 0
  loop do
    multipliers[i][:multiplier] += 1
    combination = combine_multipliers(multipliers)
    break if combination + divisor > total_amount
    result = ((total_amount.to_f - combination.to_f) / divisor.to_f)
    valid_combinations += 1 if result % 1 == 0 && result > 0
    j = 0
    until j == i
      valid_combinations += increment(total_amount, multipliers, j, divisor)
      j += 1
    end
  end
  multipliers[i][:multiplier] = 0
  return valid_combinations
end

def output_stuff(divisor, valid_combinations, multipliers, i)
  multipliers_string = multipliers.map {|multiplier| "#{multiplier[:denomination]}*#{multiplier[:multiplier]}"}.unshift("#{divisor}*∞").join(" + ")
  puts "#{i.to_s}\t#{divisor}\t#{valid_combinations}\t\t\t#{multipliers_string}"
end

# amount = 100, denominations = [1, 5, 10, 25, 50, 100]
def change_possibilities_bottom_up(amount, denominations)
  ways_of_doing_n_cents = [0] * (amount + 1)
  ways_of_doing_n_cents[0] = 1

  denominations.each do |coin|
    (coin..amount).each do |higher_amount|
      higher_amount_remainder = higher_amount - coin
      ways_of_doing_n_cents[higher_amount] += ways_of_doing_n_cents[higher_amount_remainder]
    end
  end

  return ways_of_doing_n_cents[amount]
end

def valid_combinations(amount, denominations)
  ways_of_doing_n_cents = [0] * (amount + 1)
  ways_of_doing_n_cents[0] = 1

  denominations.each do |denomination|
    (denomination..amount).each do |current_amount|
      ways_of_doing_n_cents[current_amount] += ways_of_doing_n_cents[current_amount - denomination]
    end
  end

  return ways_of_doing_n_cents[amount]
end


# amount = 100
# Benchmark.bm do |x|
#   x.report ("my method:\t") {denominations = [1, 5, 10, 25, 50, 100, 7, 18, 9]; valid_combinations(amount, denominations)}
#   x.report ("their method:\t") {denominations = [1, 5, 10, 25, 50, 100, 7, 18, 9]; change_possibilities_bottom_up(amount, denominations)}
# end


amount = 100
denominations = [1, 5, 10, 25, 50, 100]
puts valid_combinations(amount, denominations)
# amount = 100
# denominations = [1, 5, 10, 25, 50, 100]
# puts change_possibilities_bottom_up(amount, denominations)














