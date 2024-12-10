class FileBlock
  attr_accessor :id, :length, :start_position

  def initialize(id, length, start_position)
    @id = id
    @length = length
    @start_position = start_position
  end
end

class Day9
  INPUT_PATH = File.expand_path('../../../../inputs/day9/input.txt', __FILE__).freeze

  def self.checksum_contiguous_disk(disk)
    checksum = 0
    disk.each_with_index do |file_id, i|
      return checksum if file_id.nil?
      checksum += i * file_id
    end
    checksum
  end

  def self.parse_one(data)
    blocks = data.chars.map(&:to_i)
    disk = Array.new(blocks.sum)
    state = true
    head = 0
    file_id = 0
    holes = []
    files = {}

    blocks.each do |block|
      if state
        block.times { |i| disk[head + i] = file_id }
        files[file_id] = ((head + block - 1).downto(head)).to_a
        state = false
        file_id += 1
      else
        holes.concat((head...(head + block)).to_a)
        state = true
      end
      head += block
    end
    [disk, holes, files]
  end

  def self.puzzle1
    input = File.read(INPUT_PATH).strip
    disk, holes, files = parse_one(input)

    files.keys.reverse_each do |file_id|
      positions = files[file_id]
      i = 0
      while !holes.empty? && i < positions.length
        return checksum_contiguous_disk(disk) if holes[0] > positions[i]
        h = holes.shift
        disk[h] = file_id
        disk[positions[i]] = nil
        i += 1
      end
    end
    checksum_contiguous_disk(disk)
  end

  def self.parse_two(data)
    blocks = data.chars.map(&:to_i)
    disk = Array.new(blocks.sum)
    is_file = true
    current_position = 0
    file_id = 0
    empty_regions = []
    file_regions = {}

    blocks.each do |block_size|
      if is_file
        block_size.times { |i| disk[current_position + i] = file_id }
        file_regions[file_id] = [current_position, current_position + block_size]
        file_id += 1
      elsif block_size != 0
        empty_regions << [current_position, current_position + block_size]
      end
      is_file = !is_file
      current_position += block_size
    end
    [disk, empty_regions, file_regions]
  end

  def self.checksum(disk)
    sum = 0
    disk.each_with_index do |file_id, i|
      next if file_id.nil?
      sum += i * file_id
    end
    sum
  end

  def self.puzzle2
    input = File.read(INPUT_PATH).strip
    disk, empty_regions, file_regions = parse_two(input)

    file_regions.keys.reverse_each do |file_id|
      file_start, file_end = file_regions[file_id]
      file_length = file_end - file_start

      empty_regions.each_with_index do |(empty_start, empty_end), region_index|
        empty_length = empty_end - empty_start
        break if empty_start > file_start

        if file_length <= empty_length
          file_length.times { |j| disk[empty_start + j] = file_id }
          file_length.times { |j| disk[file_start + j] = nil }

          if file_length == empty_length
            empty_regions.delete_at(region_index)
          else
            empty_regions[region_index] = [empty_start + file_length, empty_end]
          end

          adjacent_before = nil
          adjacent_after = nil

          empty_regions.reverse_each.with_index do |(region_start, region_end), reverse_index|
            region_position = empty_regions.length - reverse_index - 1
            if region_start == file_end
              adjacent_after = [region_position, [region_start, region_end]]
            elsif region_end == file_start
              adjacent_before = [region_position, [region_start, region_end]]
            end
            break if region_end < file_start
          end

          if adjacent_before && adjacent_after
            i, (hs, _) = adjacent_before
            ri, (_, he) = adjacent_after
            empty_regions.delete_at(ri)
          elsif adjacent_before
            i, (hs, _) = adjacent_before
            he = file_end
          elsif adjacent_after
            i, (_, he) = adjacent_after
            hs = file_start
          else
            break
          end

          empty_regions[i] = [hs, he]
          break
        end
      end
    end

    checksum(disk)
  end
end

puts Day9.puzzle1
puts Day9.puzzle2
