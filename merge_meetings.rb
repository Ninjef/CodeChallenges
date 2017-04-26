require 'pry'
require 'benchmark'
# [ [0, 1], [3, 5], [4, 8], [10, 12], [9, 10] ]
# should produce [ [0, 1], [3, 8], [9, 12] ]

def intersection?(x,y)
  # If start of first time block is less than or equal to the end of the second time block
  # And the end of the first time block is greater than or equal to the start of the second block
  # Then there is an intersection, otherwise, no intersection
  x[1] >= y[0]
end

def merge_meetings_1(meeting_times)
  current_blocks = [meeting_times[0]]
  meeting_times.each do |meeting_time|
    i = 0
    intersection = false
    while i < current_blocks.length && intersection == false
      block = current_blocks[i]
      intersection = intersection?(meeting_time,block)
      if intersection
        # If there is an intersection...
        # Find the minimum and maximum times (for new start-end times)
        min_max_array = meeting_time + block
        new_min = min_max_array.min
        new_max = min_max_array.max
        # Replace current block with new min and new max
        current_blocks[i] = [new_min, new_max]
      end
      i += 1
    end
    current_blocks << meeting_time unless intersection
  end
  return current_blocks
end

def merge_meetings_2(meeting_times)
  current_blocks = [meeting_times[0]]
  current_minimum = meeting_times[0][0]
  current_maximum = meeting_times[0][1]

  meeting_times.each do |meeting_time|
    unless meeting_time[0] > current_maximum || meeting_time[1] < current_minimum
      i = 0
      while i < current_blocks.length
        block = current_blocks[i]
        intersection = intersection?(meeting_time,block)
        if intersection
          # If there is an intersection...
          # Find the minimum and maximum times (for new start-end times)
          min_max_array = meeting_time + block
          new_min = min_max_array.min
          new_max = min_max_array.max
          # Replace current block with new min and new max
          current_blocks[i] = [new_min, new_max]
        end
        i += 1
      end
    end
    # puts "meeting_time: #{meeting_time} | current_minimum: #{current_minimum} | current_maximum: #{current_maximum}"
    current_minimum = meeting_time[0] if meeting_time[0] < current_minimum
    current_maximum = meeting_time[1] if meeting_time[1] > current_maximum
    # puts "#{current_blocks}"
    current_blocks << meeting_time unless intersection
  end
  return current_blocks
end

def merge_meetings_3(meeting_times)
  unit = 0.5
  meeting_times.sort!
  all_filled_times = meeting_times.map {|x, y| (x..y).step(0.5).map {|i| i}}.flatten.uniq.sort
  blocks = []
  current_start_int = all_filled_times[0]
  i = 0
  while i < all_filled_times.length
    current_int = all_filled_times[i]
    next_int = all_filled_times[i+1]
    if current_int + unit != next_int
      end_int = current_int
      blocks << [current_start_int.to_i, end_int.to_i]
      current_start_int = next_int
    end
    i += 1
  end
  return blocks
end

def merge_meetings_3_2(meeting_times)
  unit = 0.5
  all_filled_times = meeting_times.sort.map {|x, y| (x..y).step(unit).map {|i| i}}.flatten.uniq
  blocks = []
  current_start_int = all_filled_times[0]
  i = 0
  while i < all_filled_times.length
    current_int = all_filled_times[i]
    next_int = all_filled_times[i+1]
    if current_int + unit != next_int
      end_int = current_int
      blocks << [current_start_int.to_i, end_int.to_i]
      current_start_int = next_int
    end
    i += 1
  end
  return blocks
end

# [[0,2], [2,5], [6,7]]
def merge_meetings_4(meeting_times)
  sorted_meeting_times = meeting_times.sort

  merged_meetings = []
  first_meeting = sorted_meeting_times[0]
  current_block_start = first_meeting[0] # 9
  current_block_end = first_meeting[1] # 54
  previous_meeting_end = current_block_end # 54

  sorted_meeting_times[1..-1].each do |current_meeting_start, current_meeting_end|
    if previous_meeting_end >= current_meeting_start # t | t | f
      current_block_end = [current_block_end, current_meeting_end].max # 54 | 5
      previous_meeting_end = current_block_end
    else
      merged_meetings << [current_block_start, current_block_end] # NA | NA | [ [0,5] ]
      current_block_start = current_meeting_start # NA | NA | 6
      current_block_end = current_meeting_end # NA | NA | 7
      previous_meeting_end = current_meeting_end # 2 | 5 | 7
    end
  end

  merged_meetings << [current_block_start, current_block_end]
  return merged_meetings
end

def merge_meetings(meeting_times)
  sorted_meeting_times = meeting_times.sort

  merged_meetings = [sorted_meeting_times[0]]

  sorted_meeting_times[1..-1].each do |current_meeting_start, current_meeting_end|
    if merged_meetings[-1][1] >= current_meeting_start
      merged_meetings[-1] = [merged_meetings[-1][0], [merged_meetings[-1][1], current_meeting_end].max]
    else
      merged_meetings << [current_meeting_start, current_meeting_end]
    end
  end

  return merged_meetings
end

  def merge_ranges(meetings)

    # sort by start times
    sorted_meetings = meetings.sort

    # initialize merged_meetings with the earliest meeting
    merged_meetings = [sorted_meetings[0]]

    sorted_meetings[1..-1].each do |current_meeting_start, current_meeting_end|

        last_merged_meeting_start, last_merged_meeting_end = merged_meetings[-1]

        # if the current and last meetings overlap, use the latest end time
        if current_meeting_start <= last_merged_meeting_end
            merged_meetings[-1] = [last_merged_meeting_start, [last_merged_meeting_end, current_meeting_end].max]

        # add the current meeting since it doesn't overlap
        else
            merged_meetings.push([current_meeting_start, current_meeting_end])
        end
    end

    return merged_meetings
end

def generate_meetings(size=1000, time_max=5000, span_max=50)
  Array.new(size).map do |i|
    start_time = rand(0..time_max)
    end_time = start_time + rand(0..span_max)
    [start_time, end_time]
  end
end

meeting_sets = Array.new(500).map do |i|
  size = rand(100..1000)
  time_max = size * rand(3..15)
  span_max = time_max / size * rand(1..3)
  generate_meetings(size, time_max, span_max)
end

Benchmark.bm do |x|
  x.report ("my method:\t") {meeting_sets.each {|meeting_set| merge_meetings_3_2(meeting_set)}}
  x.report ("their method:\t") {meeting_sets.each {|meeting_set| merge_ranges(meeting_set)}}
end

# meetings = generate_meetings
# puts merge_meetings(meetings).to_s
# puts merge_ranges(meetings).to_s
