require 'set'

class Day10
  INPUT_PATH = File.expand_path('../../../../inputs/day10/input.txt', __FILE__).freeze

  DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  def self.puzzle1
    grid = File.read(INPUT_PATH).split("\n").map { |line| line.chars.map(&:to_i) }
    sum = 0

    grid.each_with_index do |row, i|
      row.each_with_index do |_, j|
        if grid[i][j] == 0
          sum += get_count(grid, i, j)
        end
      end
    end

    sum
  end

  def self.puzzle2
    grid = File.read(INPUT_PATH).split("\n").map { |line| line.chars.map(&:to_i) }
    sum = 0

    grid.each_with_index do |row, i|
      row.each_with_index do |_, j|
        if grid[i][j] == 0
          sum += get_count_v2(grid, i, j)
        end
      end
    end

    sum
  end

  private

  def self.get_count(grid, i, j)
    queue = [[i, j]]
    seen = Set.new
    count = 0

    while !queue.empty?
      x, y = queue.shift
      num = grid[x][y]

      if num == 9
        count += 1
        next
      end

      DIRECTIONS.each do |dx, dy|
        nx, ny = x + dx, y + dy
        if nx >= 0 && nx < grid.size && ny >= 0 && ny < grid[0].size
          if grid[nx][ny] - num == 1
            next if seen.include?([nx, ny])

            seen.add([nx, ny])
            queue << [nx, ny]
          end
        end
      end
    end

    count
  end

  def self.get_count_v2(grid, i, j)
    queue = [[i, j]]
    count = 0

    while !queue.empty?
      x, y = queue.shift
      num = grid[x][y]

      if num == 9
        count += 1
        next
      end

      DIRECTIONS.each do |dx, dy|
        nx, ny = x + dx, y + dy
        if nx >= 0 && nx < grid.size && ny >= 0 && ny < grid[0].size
          if grid[nx][ny] - num == 1
            queue << [nx, ny]
          end
        end
      end
    end

    count
  end
end

puts Day10.puzzle1
puts Day10.puzzle2
