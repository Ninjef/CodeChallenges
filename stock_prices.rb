stock_prices_yesterday = [10, 7, 5, 8, 11, 9]

def get_max_profit1(stock_prices)
  if stock_prices.length < 2
      raise IndexError, 'Getting a profit requires at least 2 prices'
  end
  future_prices = Array.new(stock_prices)
  best_profit = -1.0/0.0
  lowest_price = stock_prices[0]
  stock_prices.each do |stock_price|
    lowest_price = [stock_price, lowest_price].min
    current_best_profit = stock_price - lowest_price
    best_profit = [current_best_profit, best_profit].max
  end
  return best_profit
end


  def get_max_profit2(stock_prices_yesterday)

    # make sure we have at least 2 prices
    if stock_prices_yesterday.length < 2
        raise IndexError, 'Getting a profit requires at least 2 prices'
    end

    # we'll greedily update min_price and max_profit, so we initialize
    # them to the first price and the first possible profit
    min_price = stock_prices_yesterday[0]
    max_profit = stock_prices_yesterday[1] - stock_prices_yesterday[0]

    stock_prices_yesterday.each_with_index do |current_price, index|

        # skip the first time, since we already used it
        # when we initialized min_price and max_profit
        if index == 0 then next end

        # see what our profit would be if we bought at the
        # min price and sold at the current price
        potential_profit = current_price - min_price

        # update max_profit if we can do better
        max_profit = [max_profit, potential_profit].max

        # update min_price so it's always
        # the lowest price we've seen so far
        min_price  = [min_price, current_price].min
    end

    return max_profit
end