require 'set'

class Day6
  INPUT_PATH = File.expand_path('../../../inputs/day6/input.txt', __dir__).freeze

  DIRECTIONS = {
    UP: [-1, 0],
    RIGHT: [0, 1],
    DOWN: [1, 0],
    LEFT: [0, -1]
  }.freeze

  Cell = {
    EMPTY: '.',
    OBSTRUCTION: '#',
    GUARD: '^',
    VISITED_UP: '^',
    VISITED_RIGHT: '>',
    VISITED_DOWN: 'v',
    VISITED_LEFT: '<'
  }.freeze

  def self.puzzle1
    grid = File.readlines(INPUT_PATH, chomp: true).map(&:chars)
    predict_guard_movement(grid)

    # Count visited positions
    count = 0
    grid.each do |row|
      row.each do |cell|
        count += 1 if cell.match?(/[^.#]/)  # Count anything that's not empty or wall
      end
    end

    # Debug output
    # grid.each { |row| puts row.join }

    count
  end

  def self.puzzle2
    grid = File.readlines(INPUT_PATH, chomp: true).map(&:chars)
    guard_position = find_guard_position(grid)
    original_grid = grid.map(&:dup)

    # Get visited positions from original path
    predict_guard_movement(grid)
    visited_positions = Set.new

    grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        visited_positions.add([i, j]) if cell.match?(/[^.#]/)
      end
    end

    # Remove guard's starting position
    visited_positions.delete(guard_position)

    # Try putting obstruction at each visited position
    loop_count = 0

    visited_positions.each do |pos|
      i, j = pos
      next unless original_grid[i][j] == Cell[:EMPTY]

      test_grid = original_grid.map(&:dup)
      test_grid[i][j] = Cell[:OBSTRUCTION]

      loop_count += 1 if creates_loop?(test_grid)
    end

    loop_count
  end

  private

  def self.predict_guard_movement(grid)
    direction_index = 0
    visited_positions = Set.new
    x, y = find_guard_position(grid)

    loop do
      dir = DIRECTIONS.values[direction_index]
      current_dir = DIRECTIONS.keys[direction_index]

      # Mark current position as visited with direction
      visited_positions.add([x, y, current_dir])
      grid[x][y] = direction_to_arrow(current_dir)

      new_x = x + dir[0]
      new_y = y + dir[1]

      # Check boundaries
      return false if out_of_bounds?(new_x, new_y, grid)

      # Check for loops
      return true if visited_positions.include?([new_x, new_y, current_dir])

      if grid[new_x][new_y] == Cell[:OBSTRUCTION]
        direction_index = (direction_index + 1) % 4
      else
        x = new_x
        y = new_y
      end
    end
  end

  def self.find_guard_position(grid)
    grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        return [i, j] if cell == Cell[:GUARD]
      end
    end
    nil
  end

  def self.out_of_bounds?(x, y, grid)
    x < 0 || x >= grid.size || y < 0 || y >= grid[0].size
  end

  def self.direction_to_arrow(direction)
    case direction
    when :UP then Cell[:VISITED_UP]
    when :RIGHT then Cell[:VISITED_RIGHT]
    when :DOWN then Cell[:VISITED_DOWN]
    when :LEFT then Cell[:VISITED_LEFT]
    end
  end

  def self.creates_loop?(grid)
    test_grid = grid.map(&:dup)
    predict_guard_movement(test_grid)
  end
end


puts Day6.puzzle1
puts Day6.puzzle2
