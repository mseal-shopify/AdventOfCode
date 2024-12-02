class Day2
  INPUT_PATH = File.expand_path('../../../../inputs/day2/input.txt', __FILE__).freeze

  def self.puzzle_1
    File.readlines(INPUT_PATH, chomp: true)
    .map(&:strip)
    .count do |line|
      numbers = line.split(" ").map(&:to_i)

      is_increasing = numbers[1] > numbers[0]

      (1...numbers.length).all? do |i|
        diff = numbers[i] - numbers[i - 1]
        (is_increasing && diff >= 1 && diff <= 3) || (!is_increasing && diff <= -1 && diff >= -3)
      end
    end
  end

  def self.puzzle_2
    File.readlines(INPUT_PATH, chomp: true)
      .map(&:strip)
      .count do |line|
        numbers = line.split(" ").map(&:to_i)

        next true if is_safe_report?(numbers)

        numbers.each_index.any? do |skip_index|
          test_numbers = numbers[0...skip_index] + numbers[skip_index + 1..]
          is_safe_report?(test_numbers)
        end
      end
  end

  private

  def self.is_safe_report?(numbers)
    is_increasing = numbers[1] > numbers[0]

    (1...numbers.length).all? do |i|
      diff = numbers[i] - numbers[i - 1]
      (is_increasing && diff >= 1 && diff <= 3) || (!is_increasing && diff <= -1 && diff >= -3)
    end
  end
end

puts Day2.puzzle_1
puts Day2.puzzle_2
