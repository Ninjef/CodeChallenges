require "pry"
require 'benchmark'

# def find_love_intersection_1(rectangle_1, rectangle_2)
#   x1, y1 = contained_rectangle_values(rectangle_1)
#   x2, y2 = contained_rectangle_values(rectangle_2)

#   intersecting_x = (x1 - (x1 - x2))
#   intersecting_y = (y1 - (y1 - y2))

#   if intersecting_x.empty? || intersecting_y.empty? || intersecting_x.length == 1 || intersecting_y.length == 1
#     love_rectangle = {}
#   else
#     love_rectangle = love_rectangle_format(intersecting_x.min, intersecting_y.min, intersecting_x.length - 1, intersecting_y.length)
#   end

#   return love_rectangle
# end

# def love_rectangle_format(x_start, y_start, width, height)
#   {
#     # coordinates of bottom-left corner
#     'left_x' => x_start,
#     'bottom_y' => y_start,

#     # width and height
#     'width' => width,
#     'height' => height
#     }
# end

# def contained_rectangle_values(rectangle)
#   x1 = contained_axis_values(rectangle['left_x'], rectangle['width'])
#   y1 = contained_axis_values(rectangle['bottom_y'], rectangle['height'])

#   return x1, y1
# end

# def contained_axis_values(start_value, length)
#   end_value = start_value + length
#   return (start_value..end_value).to_a
# end

def find_love_intersection(rectangle_1, rectangle_2)
  x1 = [rectangle_1["left_x"], rectangle_1["left_x"] + rectangle_1["width"]]
  y1 = [rectangle_2["bottom_y"], rectangle_2["bottom_y"] + rectangle_2["height"]]

  x2 = [rectangle_2["left_x"], rectangle_2["left_x"] + rectangle_2["width"]]
  y2 = [rectangle_2["bottom_y"], rectangle_2["bottom_y"] + rectangle_2["height"]]

  x1 # ... blah blah yeah I got it :-\ (frustrated that I didn't go with the math option in my solution)
end

def find_range_overlap(point1, length1, point2, length2)

    # find the highest start point and lowest end point.
    # the highest ("rightmost" or "upmost") start point is
    # the start point of the overlap.
    # the lowest end point is the end point of the overlap.
    highest_start_point = [point1, point2].max
    lowest_end_point = [point1 + length1, point2 + length2].min

    # return nil overlap if there is no overlap
    if highest_start_point >= lowest_end_point
        return [nil, nil]
    end

    # compute the overlap length
    overlap_length = lowest_end_point - highest_start_point

    return [highest_start_point, overlap_length]
end

def find_rectangular_overlap(rect1, rect2)

    # get the x and y overlap points and lengths
    x_overlap_point, overlap_width  = find_range_overlap(\
        rect1['left_x'], rect1['width'],  rect2['left_x'], rect2['width'])
    y_overlap_point, overlap_height = find_range_overlap(\
        rect1['bottom_y'], rect1['height'], rect2['bottom_y'], rect2['height'])

    # return nil rectangle if there is no overlap
    if !overlap_width || !overlap_height
        return {
            'left_x' => nil,
            'bottom_y' => nil,
            'width' => nil,
            'height' => nil,
        }
    end

    return {
        'left_x' => x_overlap_point,
        'bottom_y' => y_overlap_point,
        'width' => overlap_width,
        'height' => overlap_height,
    }
end


person_1_rectangle = {

    # coordinates of bottom-left corner
    'left_x' => -2000,
    'bottom_y' => 500,

    # width and height
    'width' => 2800,
    'height' => 6000

}

person_2_rectangle = {

    # coordinates of bottom-left corner
    'left_x' => 300,
    'bottom_y' => 750,

    # width and height
    'width' => 762,
    'height' => 900

}

n = 10
Benchmark.bm do |x|
  x.report ("my method:\t") {n.times {find_love_intersection(person_1_rectangle, person_2_rectangle)}}
  x.report ("their method:\t") {n.times {find_rectangular_overlap(person_1_rectangle, person_2_rectangle)}}
end


puts find_love_intersection(person_1_rectangle, person_2_rectangle)
puts find_rectangular_overlap(person_1_rectangle, person_2_rectangle)


