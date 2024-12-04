class Day4
  INPUT_PATH = File.expand_path('../../../../inputs/day4/input.txt', __FILE__).freeze

    FORWARD = [[0, 0], [0, 1], [0, 2], [0, 3]]
    DOWN = [[0, 0], [1, 0], [2, 0], [3, 0]]
    BACKWARD = [[0, 0], [0, -1], [0, -2], [0, -3]]
    UP = [[0, 0], [-1, 0], [-2, 0], [-3, 0]]
    DIAGONAL_RIGHT_DOWN = [[0, 0], [1, 1], [2, 2], [3, 3]]
    DIAGONAL_LEFT_UP = [[0, 0], [-1, -1], [-2, -2], [-3, -3]]
    DIAGONAL_LEFT_DOWN = [[0, 0], [1, -1], [2, -2], [3, -3]]
    DIAGONAL_RIGHT_UP = [[0, 0], [-1, 1], [-2, 2], [-3, 3]]

    ALL_DIRECTIONS = [FORWARD, DOWN, BACKWARD, UP, DIAGONAL_RIGHT_DOWN, DIAGONAL_LEFT_UP, DIAGONAL_LEFT_DOWN, DIAGONAL_RIGHT_UP].freeze
    XMAS = "XMAS"

    X_SHAPE = [[0, 0], [-1, -1], [1, 1], [1, -1], [-1, 1]].freeze
    WORDS = ["ASMSM", "AMSMS", "AMSSM", "ASMMS"].freeze

    def self.puzzle1
        matrix  = File.readlines(INPUT_PATH, chomp: true).map do |line|
            line.chars
        end

        xmas_count = 0
        rows = matrix.length
        cols = matrix[0].length

        (0...rows).each do |row|
            (0...cols).each do |col|
                ALL_DIRECTIONS.each do |direction|
                  word = ""
                  direction.each do |row_offset, col_offset|
                    new_row = row + row_offset
                    new_col = col + col_offset
                    if new_row >= 0 && new_row < rows && new_col >= 0 && new_col < cols
                      word += matrix[new_row][new_col].to_s
                    end
                  end
                  xmas_count += 1 if word == XMAS
                end
            end
        end

        xmas_count
    end


    def self.puzzle2
      matrix = File.readlines(INPUT_PATH, chomp: true).map do |line|
        line.chars
      end

      xmas_count = 0
      rows = matrix.length
      cols = matrix[0].length

      (0...rows).each do |row|
        (0...cols).each do |col|
          word = ""

          X_SHAPE.each do |row_offset, col_offset|
            new_row = row + row_offset
            new_col = col + col_offset

            if new_row >= 0 && new_row < rows && new_col >= 0 && new_col < cols
              word += matrix[new_row][new_col].to_s
            end
          end

          xmas_count += 1 if WORDS.include?(word)
        end
      end

      xmas_count
    end
end


puts Day4.puzzle1
puts Day4.puzzle2
