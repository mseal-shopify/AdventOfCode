class Day1
  INPUT_PATH = 'Day1/input.txt'.freeze

  def self.puzzle_1
    # Read and process input in a single pass
    locations = File.readlines(INPUT_PATH, chomp: true).map do |line|
      left, right = line.split
      [left.to_i, right.to_i]
    end.transpose

    # Calculate total distance using array operations
    left_sorted, right_sorted = locations.map(&:sort)
    left_sorted.zip(right_sorted).sum { |left, right| (left - right).abs }
  end

  def self.puzzle_2
    # Read file once and split into two arrays
    locations = File.readlines(INPUT_PATH, chomp: true).map do |line|
      left, right = line.split
      [left.to_i, right.to_i]
    end.transpose

    left_locations, right_locations = locations

    # Create hash map counting occurrences in right locations
    right_location_map = Hash.new(0)
    right_locations.each { |num| right_location_map[num] += 1 }

    similarity_score = 0
    left_locations.each do |left_location|
      similarity_score += (left_location * right_location_map[left_location])
    end

    similarity_score
  end
end

puts Day1.puzzle_1
puts Day1.puzzle_2
