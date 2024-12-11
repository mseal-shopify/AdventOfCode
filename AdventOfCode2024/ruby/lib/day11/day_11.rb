require 'set'

class Day11

  def self.puzzle1
    stones = "965842 9159 3372473 311 0 6 86213 48".split(" ").map(&:to_i)

    (0..24).each do |i|
      new_stones = []
      stones.each do |stone|
        if stone == 0
          new_stones << 1
        elsif stone.to_s.length % 2 == 0
          first_half = stone.to_s[0..stone.to_s.length / 2 - 1].to_i
          second_half = stone.to_s[stone.to_s.length / 2..-1].to_i
          new_stones << first_half
          new_stones << second_half
        else
          new_stones << stone * 2024
        end
      end
      stones = new_stones
    end

    stones.length
  end

  def self.puzzle2
    stones = "965842 9159 3372473 311 0 6 86213 48".split(" ").map(&:to_i)
    memo = {}

    def self.process_stone(stone, memo, depth = 75)
      return memo[[stone, depth]] if memo.key?([stone, depth])
      return 1 if depth == 0

      result = if stone == 0
        process_stone(1, memo, depth - 1)
      elsif stone.to_s.length % 2 == 0
        first_half = stone.to_s[0..stone.to_s.length / 2 - 1].to_i
        second_half = stone.to_s[stone.to_s.length / 2..-1].to_i
        process_stone(first_half, memo, depth - 1) +
        process_stone(second_half, memo, depth - 1)
      else
        process_stone(stone * 2024, memo, depth - 1)
      end

      memo[[stone, depth]] = result
      result
    end

    stones.sum { |stone| process_stone(stone, memo) }
  end
end


puts Day11.puzzle1
puts Day11.puzzle2
