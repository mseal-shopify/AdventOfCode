package day8;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class Day8 {

    public static final String INPUT_PATH = "../../../../inputs/day8/input.txt";

    public static void main(String[] args) throws IOException {
        System.out.println(puzzle1());
        System.out.println(puzzle2());
    }

    public static int puzzle1() throws IOException {
        List<String> lines = Files.readAllLines(Paths.get(INPUT_PATH));
        char[][] grid = lines.stream()
                .map(String::toCharArray)
                .toArray(char[][]::new);

        Map<Character, Set<Position>> freqPositions = new HashMap<>();
        Set<Position> antinodes = new HashSet<>();

        for (int i = 0; i < grid.length; i++) {
            for (int j = 0; j < grid[i].length; j++) {
                if (grid[i][j] != '.') {
                    freqPositions.computeIfAbsent(grid[i][j], k -> new HashSet<>()).add(new Position(i, j));
                }
            }
        }

        for (Set<Position> positions : freqPositions.values()) {
            
        }

        return antinodes.size();
    }

    public static int puzzle2() throws IOException {
        List<String> lines = Files.readAllLines(Paths.get(INPUT_PATH));
        char[][] grid = lines.stream()
                .map(String::toCharArray)
                .toArray(char[][]::new);

        Set<Position> antinodes = new HashSet<>();

        return antinodes.size();
    }
}

