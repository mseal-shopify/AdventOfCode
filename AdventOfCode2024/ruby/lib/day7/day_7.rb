class Day7

  INPUT_PATH = File.expand_path('../../../../inputs/day7/input.txt', __FILE__).freeze

  def self.puzzle1
    input = File.read(INPUT_PATH).split("\n")

    total_calibration_result = 0
    input.each do |line|
      target, numbers = line.split(':').map(&:strip)
      target = target.to_i
      numbers = numbers.split(/\s+/).map(&:to_i)
      total_calibration_result += target if can_make_value?(numbers, target)
    end

    total_calibration_result
  end

  def self.puzzle2
    input = File.read(INPUT_PATH).split("\n")

    total_calibration_result = 0
    input.each do |line|
      target, numbers = line.split(':').map(&:strip)
      target = target.to_i
      numbers = numbers.split(/\s+/).map(&:to_i)
      total_calibration_result += target if can_make_value_v2?(numbers, target)
    end

    total_calibration_result
  end

  def self.can_make_value?(numbers, target, current_value = nil, remaining_numbers = nil)
    # Initial setup on first call
    if remaining_numbers.nil?
      return false if numbers.empty?
      remaining_numbers = numbers.dup
      current_value = remaining_numbers.shift
    end

    # Base case: if no more numbers and current value equals target
    return current_value == target if remaining_numbers.empty?

    next_num = remaining_numbers[0]
    next_remaining = remaining_numbers[1..]

    # Try addition
    return true if can_make_value?(numbers, target, current_value + next_num, next_remaining)

    # Try multiplication
    return true if can_make_value?(numbers, target, current_value * next_num, next_remaining)

    # If neither operation works, return false
    false
  end

  def self.can_make_value_v2?(numbers, target, current_value = nil, remaining_numbers = nil)
    # Initial setup on first call
    if remaining_numbers.nil?
      return false if numbers.empty?
      remaining_numbers = numbers.dup
      current_value = remaining_numbers.shift
    end

    # Base case: if no more numbers and current value equals target
    return current_value == target if remaining_numbers.empty?

    next_num = remaining_numbers[0]
    next_remaining = remaining_numbers[1..]

    # Try addition
    return true if can_make_value_v2?(numbers, target, current_value + next_num, next_remaining)

    # Try multiplication
    return true if can_make_value_v2?(numbers, target, current_value * next_num, next_remaining)

    # Try concatenation
    return true if can_make_value_v2?(numbers, target, (current_value.to_s + next_num.to_s).to_i, next_remaining)

    # If neither operation works, return false
    false
  end
end


puts Day7.puzzle1
puts Day7.puzzle2
