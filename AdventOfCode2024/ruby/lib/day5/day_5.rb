require 'set'

class Day5
  INPUT_PATH = File.expand_path('../../../../inputs/day5/input.txt', __FILE__).freeze

  def self.puzzle1
    rules_section, updates_section = File.read(INPUT_PATH).split("\n\n").map(&:split)

    rules = {}
    rules_section.each do |rule|
      num1, num2 = rule.split('|').map(&:to_i)
      rules[num1] ||= Set.new
      rules[num1].add(num2)
    end

    mid_sum = 0
    updates_section.each do |update|
      pages = update.split(',').map(&:to_i)
      valid = true;

      (0...pages.length - 1).each do |i|
        current_page = pages[i]
        next_page = pages[i + 1]

        unless rules[current_page]&.include?(next_page)
          valid = false
          break
        end
      end

      if valid
        mid_index = (pages.length - 1) / 2
        mid_sum += pages[mid_index]
      end
    end

    mid_sum
  end

  def self.puzzle2
    rules_section, updates_section = File.read(INPUT_PATH).split("\n\n").map(&:split)

    rules = {}
    rules_section.each do |rule|
      num1, num2 = rule.split('|').map(&:to_i)
      rules[num1] ||= Set.new
      rules[num1].add(num2)
    end

    mid_sum = 0
    updates_section.each do |update|
      pages = update.split(',').map(&:to_i)

      unless is_valid_update(rules, pages)
        reorder_pages(rules, pages)
        mid_sum += pages[(pages.length - 1) / 2]
      end
    end

    mid_sum
  end

  def self.is_valid_update(rules, pages)
    valid = true;

    (0...pages.length - 1).each do |i|
      current_page = pages[i]
      next_page = pages[i + 1]

      unless rules[current_page]&.include?(next_page)
        valid = false
        break
      end
    end

    valid
  end

  def self.reorder_pages(rules, pages)
    n = pages.length

    loop do
      swapped = false

      (0...n - 1).each do |i|
        current_page = pages[i]
        next_page = pages[i + 1]

        unless rules[current_page]&.include?(next_page)
          pages[i], pages[i + 1] = pages[i + 1], pages[i]
          swapped = true
        end
      end

      break unless swapped
    end
  end
end

puts Day5.puzzle1
puts Day5.puzzle2
