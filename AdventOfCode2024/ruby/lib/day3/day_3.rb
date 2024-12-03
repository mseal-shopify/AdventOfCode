class Day3
    INPUT_PATH = File.expand_path('../../../../inputs/day3/input.txt', __FILE__).freeze
    MUL_PATTERN = /mul\((?<a>\d+),(?<b>\d+)\)/
    DO_PATTERN = /do\(\)/
    DONT_PATTERN = /don't\(\)/

    def self.puzzle1
        content = File.read(INPUT_PATH)
        content.scan(MUL_PATTERN).map { |a, b| parse_multiplication("mul(#{a},#{b})") }.sum
    end


    def self.puzzle2
        content = File.read(INPUT_PATH)
        process_with_instructions(content)
    end

    private

    def self.process_with_instructions(content)
        sum = 0
        enabled = true
        position = 0

        while position < content.length
            do_matcher = content[position..-1].match(DO_PATTERN)
            dont_matcher = content[position..-1].match(DONT_PATTERN)
            mul_matcher = content[position..-1].match(MUL_PATTERN)

            if do_matcher && do_matcher.begin(0) == 0
                enabled = true
                position += do_matcher.end(0)
            elsif dont_matcher && dont_matcher.begin(0) == 0
                enabled = false
                position += dont_matcher.end(0)
            elsif mul_matcher && mul_matcher.begin(0) == 0 && enabled
                sum += parse_multiplication(mul_matcher.to_s)
                position += mul_matcher.end(0)
            else
                position += 1
            end
        end

        sum
    end

    def self.parse_multiplication(expression)
      numbers = expression.gsub('mul(', '').gsub(')', '').split(',')
      begin
        num1, num2 = numbers.map(&:to_i)
        num1 * num2
      rescue
        "Invalid input"
      end
    end
end

puts Day3.puzzle1
puts Day3.puzzle2
