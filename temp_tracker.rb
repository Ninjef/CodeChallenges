require 'pry'
require 'benchmark'

# class TempTracker_1

#   MIN_POSSIBLE_TEMPERATURE = 0
#   MAX_POSSIBLE_TEMPERATURE = 110

#   def initialize(temperatures = [])
#     @temperatures = temperatures
    
#     @max_temperature = temperatures.max || MIN_POSSIBLE_TEMPERATURE
#     @min_temperature = temperatures.min || MAX_POSSIBLE_TEMPERATURE
    
#     @temperature_count = temperatures.length
#     @temperature_total = temperatures.reduce(:+).to_f
#     @mean_temperature = @temperature_total / @temperature_count
    
#     mode_hash = {}
#     temperatures.each {|temperature| mode_hash[temperature] = (mode_hash[temperature] || 0) + 1}

#     @mode_temp_and_occurrence = mode_hash.max_by {|temperature, occurrence| occurrence}
#     @mode = @mode_temp_and_occurrence[0]
#     @mode_occurrence = @mode_temp_and_occurrence[1]

#     @occurrence_difference_from_mode = {}
#     mode_hash.each {|temperature, occurrence| @occurrence_difference_from_mode[temperature] = @mode_occurrence - occurrence}
#   end

#   def insert(temperature)
#     @temperatures.push
    
#     @max_temperature = [@max_temperature, temperature].max
#     @min_temperature = [@min_temperature, temperature].min
    
#     @temperature_count += 1
#     @temperature_total += temperature
#     @mean_temperature = @temperature_total / @temperature_count
    
#     if temperature == @mode
#       @occurrence_difference_from_mode.each {|temperature, difference| @occurrence_difference_from_mode[temperature] += 1 unless temperature == @mode}
#       @mode_occurrence += 1
#     else
#       @occurrence_difference_from_mode[temperature] = @occurrence_difference_from_mode[temperature] ? @occurrence_difference_from_mode[temperature] - 1 : @mode_occurrence - 1
#       if @occurrence_difference_from_mode[temperature] == 0
#         @mode = temperature
#         @mode_occurrence += 1
#       end
#     end
#     return self
#   end

#   def get_max
#     @max_temperature if @temperatures
#   end

#   def get_min
#     @min_temperature if @temperatures
#   end

#   def get_mean
#     @mean_temperature
#   end

#   def get_mode
#     @mode
#   end

#   private

#   def push_to_mode_hash(temperature)
#     @mode_hash[temperature] = (@mode_hash[temperature] || 0) + 1
#   end
# end

class TempTracker

  attr_reader :temperatures

  def initialize(temperatures = [])
    @temperatures = temperatures
    
    @max_temperature = temperatures.max
    @min_temperature = temperatures.min
    
    @temperature_count = temperatures.length
    @temperature_total = temperatures.reduce(:+).to_f
    @mean_temperature = @temperature_total / @temperature_count
    
    @mode_hash = {}

    temperatures.each {|temperature| add_to_mode_hash(temperature)}

    @mode = @mode_hash.max_by {|temperature, occurrence| occurrence}[0]
  end

  def insert(temperature)
    @max_temperature = @max_temperature ? [@max_temperature, temperature].max : temperature
    @min_temperature = @min_temperature ? [@min_temperature, temperature].min : temperature
    
    @temperature_count += 1
    @temperature_total += temperature
    @mean_temperature = @temperature_total / @temperature_count

    add_to_mode_hash(temperature)
    # If the most recent temperature's occurrence is at least as big as the mode's occurrence,
    #  that temperature is the new mode
    @mode = temperature if @mode_hash[temperature] >= @mode_hash[@mode]

    return self
  end

  def get_max
    @max_temperature
  end

  def get_min
    @min_temperature
  end

  def get_mean
    @mean_temperature
  end

  def get_mode
    @mode
  end

  private

  def add_to_mode_hash(temperature)
    @mode_hash[temperature] = (@mode_hash[temperature] || 0) + 1
  end
end

my_temps = TempTracker.new([5,22,76,78,79,76,71,72])

binding.pry

puts "done"
