require 'set'

class Day12
  INPUT_PATH = File.expand_path('../../../../inputs/day12/input.txt', __FILE__).freeze


  def self.puzzle1
    matrix = File.readlines(INPUT_PATH, chomp: true).map(&:chars)
    get_cost(matrix)
  end

  def self.get_cost(grid)
    visited_global = Array.new(grid.length) { Array.new(grid[0].length, false) }
    total_cost = 0

    grid.each_with_index do |row, i|
      row.each_with_index do |_, j|
        next if visited_global[i][j]

        perimeter, area = bfs(grid, i, j, visited_global)
        total_cost += perimeter * area
      end
    end

    total_cost
  end

  def self.puzzle2
    matrix = File.readlines(INPUT_PATH, chomp: true).map(&:chars)
    get_cost_sides(matrix)
  end

  def self.get_cost_sides(grid)
    visited_global = Array.new(grid.length) { Array.new(grid[0].length, false) }
    total_cost = 0

    grid.each_with_index do |row, i|
      row.each_with_index do |_, j|
        next if visited_global[i][j]

        sides, area = bfs_sides(grid, i, j, visited_global)
        total_cost += sides * area
      end
    end

    total_cost
  end

  def self.bfs(grid, start_x, start_y, visited_global)
    queue = [[start_x, start_y]]
    current_plant = grid[start_x][start_y]
    perimeter = 0
    area = 1
    visited_global[start_x][start_y] = true
    directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]

    while !queue.empty?
      x, y = queue.shift

      directions.each do |dx, dy|
        next_x = x + dx
        next_y = y + dy

        if next_x < 0 || next_x >= grid.length || next_y < 0 || next_y >= grid[0].length
          perimeter += 1
          next
        end

        if grid[next_x][next_y] != current_plant
          perimeter += 1
          next
        end

        next if visited_global[next_x][next_y]

        visited_global[next_x][next_y] = true
        queue << [next_x, next_y]
        area += 1
      end
    end

    [perimeter, area]
  end

  def self.bfs_sides(grid, start_x, start_y, visited_global)
    queue = [[start_x, start_y]]
    current_plant = grid[start_x][start_y]
    area = 1
    visited_global[start_x][start_y] = true
    corners = Set.new

    # Define corner patterns (adjacent1, adjacent2, diagonal)
    corner_patterns = [
      [[0, 1], [1, 0], [1, 1]],     # bottom right
      [[1, 0], [0, -1], [1, -1]],   # bottom left
      [[0, -1], [-1, 0], [-1, -1]], # top left
      [[-1, 0], [0, 1], [-1, 1]]    # top right
    ]

    while !queue.empty?
      x, y = queue.shift

      # Check for corners
      corner_patterns.each do |pattern|
        adj1_dx, adj1_dy = pattern[0]
        adj2_dx, adj2_dy = pattern[1]
        diag_dx, diag_dy = pattern[2]

        # Check adjacent cells
        adj1_x, adj1_y = x + adj1_dx, y + adj1_dy
        adj2_x, adj2_y = x + adj2_dx, y + adj2_dy
        diag_x, diag_y = x + diag_dx, y + diag_dy

        # Get cell values (consider out of bounds as different from current_plant)
        adj1_different = !in_bounds?(adj1_x, adj1_y, grid) || grid[adj1_x][adj1_y] != current_plant
        adj2_different = !in_bounds?(adj2_x, adj2_y, grid) || grid[adj2_x][adj2_y] != current_plant
        diag_different = !in_bounds?(diag_x, diag_y, grid) || grid[diag_x][diag_y] != current_plant

        # Check corner conditions
        if (adj1_different && adj2_different) ||
           (!adj1_different && !adj2_different && diag_different)
          corners.add([x, y])
        end
      end

      # Continue BFS
      [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |dx, dy|
        next_x = x + dx
        next_y = y + dy

        next if !in_bounds?(next_x, next_y, grid) ||
                visited_global[next_x][next_y] ||
                grid[next_x][next_y] != current_plant

        visited_global[next_x][next_y] = true
        queue << [next_x, next_y]
        area += 1
      end
    end

    [corners.size, area]
  end

  def self.in_bounds?(x, y, grid)
    x >= 0 && x < grid.length && y >= 0 && y < grid[0].length
  end

end

puts Day12.puzzle1
puts Day12.puzzle2
