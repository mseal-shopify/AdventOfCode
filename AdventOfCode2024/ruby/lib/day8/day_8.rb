require 'set'

class Day8
  INPUT_PATH = File.expand_path('../../../../inputs/day8/input.txt', __FILE__).freeze

  def self.puzzle1
    grid = File.read(INPUT_PATH).split("\n").map { |line| line.chars }
    freq_positions = {}

    grid.each_with_index do |row, i|
      row.each_with_index do |c, j|
        if c != '.'
          freq_positions[c] ||= Set.new
          freq_positions[c].add([i, j])
        end
      end
    end

    antinodes = Set.new

    freq_positions.each do |symbol, positions|
      positions.to_a.combination(2).each do |pos1, pos2|
        y1, x1 = pos1
        y2, x2 = pos2

        # Calculate direction vector
        dy = y2 - y1
        dx = x2 - x1

        # Check point before the pattern
        p1 = [y1 - dy, x1 - dx]
        antinodes.add(p1) if p1[0].between?(0, grid.size-1) &&
                            p1[1].between?(0, grid[0].size-1)

        # Check point after the pattern
        p2 = [y2 + dy, x2 + dx]
        antinodes.add(p2) if p2[0].between?(0, grid.size-1) &&
                            p2[1].between?(0, grid[0].size-1)
      end
    end

    antinodes.size
  end

  def self.puzzle2
    grid = File.read(INPUT_PATH).split("\n").map { |line| line.chars }
    freq_positions = {}

    grid.each_with_index do |row, i|
      row.each_with_index do |c, j|
        if c != '.'
          freq_positions[c] ||= Set.new
          freq_positions[c].add([i, j])
        end
      end
    end

    antinodes = Set.new

    freq_positions.each do |symbol, positions|
      positions.to_a.combination(2).each do |pos1, pos2|
        y1, x1 = pos1
        y2, x2 = pos2

        antinodes.add([y1, x1])
        antinodes.add([y2, x2])

        # Calculate direction vector
        dy = y2 - y1
        dx = x2 - x1

        # Check point before the pattern
        p1 = [y1 - dy, x1 - dx]
        while p1[0].between?(0, grid.size-1) && p1[1].between?(0, grid[0].size-1)
          antinodes.add(p1)
          p1 = [p1[0] - dy, p1[1] - dx]
        end

        # Check point after the pattern
        p2 = [y2 + dy, x2 + dx]
        while p2[0].between?(0, grid.size-1) && p2[1].between?(0, grid[0].size-1)
          antinodes.add(p2)
          p2 = [p2[0] + dy, p2[1] + dx]
        end
      end
    end

    antinodes.size
  end
end


puts Day8.puzzle1
puts Day8.puzzle2
