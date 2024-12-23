class Day13
  class << self

    INPUT_PATH = File.expand_path('../../../../inputs/day13/input.txt', __FILE__).freeze
    ADJUSTMENT = 10000000000000

    def puzzle1
      input = File.read(INPUT_PATH)
      solve(input)
    end

    def puzzle2
      input = File.read(INPUT_PATH)
      0
    end

    def parse_input(input)
      machines = []
      current_machine = {}

      input.each_line do |line|
        line = line.strip
        next if line.empty?

        if line.start_with?('Button')
          # Parse button line
          button, moves = line.split(': ')
          button = button[-1] # Get 'A' or 'B'
          x, y = moves.split(', ')
          x = x[2..].to_i  # Remove 'X+' and convert to integer
          y = y[2..].to_i  # Remove 'Y+' and convert to integer

          current_machine[button] = [x, y]
        elsif line.start_with?('Prize')
          # Parse prize line
          x, y = line.split(': ')[1].split(', ')
          x = x[2..].to_i  # Remove 'X=' and convert to integer
          y = y[2..].to_i  # Remove 'Y=' and convert to integer

          current_machine['prize'] = [x, y]
          machines << current_machine
          current_machine = {}
        end
      end

      machines
    end

    def parse_input_v2(input)
      machines = []
      current_machine = {}

      input.each_line do |line|
        line = line.strip
        next if line.empty?

        if line.start_with?('Button')
          # Parse button line
          button, moves = line.split(': ')
          button = button[-1] # Get 'A' or 'B'
          x, y = moves.split(', ')
          x = x[2..].to_i  # Remove 'X+' and convert to integer
          y = y[2..].to_i  # Remove 'Y+' and convert to integer

          current_machine[button] = [x, y]
        elsif line.start_with?('Prize')
          # Parse prize line
          x, y = line.split(': ')[1].split(', ')
          x = x[2..].to_i + ADJUSTMENT # Remove 'X=' and convert to integer
          y = y[2..].to_i + ADJUSTMENT # Remove 'Y=' and convert to integer

          current_machine['prize'] = [x, y]
          machines << current_machine
          current_machine = {}
        end
      end

      machines
    end

    def solve_machine(machine)
      # Get button movements and prize location
      a_x, a_y = machine['A']
      b_x, b_y = machine['B']
      prize_x, prize_y = machine['prize']

      min_tokens = Float::INFINITY

      # Try different combinations of button presses
      # We can limit the search space by considering that we need positive integers
      max_a = (prize_x / a_x.to_f).ceil + 1

      (0..max_a).each do |a_presses|
        # Calculate remaining X distance after pressing A
        remaining_x = prize_x - (a_x * a_presses)

        # Skip if remaining X can't be achieved with B presses
        next if remaining_x < 0
        next if b_x == 0 && remaining_x != 0

        # Calculate required B presses for X axis
        b_presses = b_x == 0 ? 0 : (remaining_x.to_f / b_x).round
        next if b_presses < 0

        # Verify X solution
        next if (a_x * a_presses + b_x * b_presses) != prize_x

        # Verify Y solution
        next if (a_y * a_presses + b_y * b_presses) != prize_y

        # Calculate tokens (A costs 3, B costs 1)
        tokens = a_presses * 3 + b_presses * 1
        min_tokens = [min_tokens, tokens].min
      end

      min_tokens
    end

    def solve(input)
      machines = parse_input(input)
      total_tokens = 0

      machines.each do |machine|
        tokens = solve_machine(machine)
        total_tokens += tokens unless tokens == Float::INFINITY
      end

      total_tokens
    end
  end
end

# Example usage:
input = <<~INPUT
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
INPUT

puts Day13.solve(input)

puts Day13.puzzle1
puts Day13.puzzle2
