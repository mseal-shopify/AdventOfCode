package day6;

import java.util.HashSet;
import java.util.Set;
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.nio.file.Paths;

public class Day6 {

    public static final String INPUT_PATH = "../../../../inputs/day6/input.txt";

    private static final int[][] DIRECTIONS = {
        {-1, 0},  // UP
        {0, 1},   // RIGHT
        {1, 0},   // DOWN
        {0, -1}   // LEFT
    };

    private static class Cell {
        static final char EMPTY = '.';
        static final char OBSTRUCTION = '#';
        static final char GUARD = '^';
        static final char VISITED_UP = '^';
        static final char VISITED_RIGHT = '>';
        static final char VISITED_DOWN = 'v';
        static final char VISITED_LEFT = '<';
    }

    public static void main(String[] args) throws IOException {
        char[][] grid = readInput();
        char[][] originalGrid = deepCopy(grid);
        System.out.println(puzzle1(grid));
        System.out.println(puzzle2(originalGrid));
    }

    public static int puzzle1(char[][] grid) {
        predictGuardMovement(grid);

        // Count visited positions
        int count = 0;
        for (char[] row : grid) {
            for (char cell : row) {
                if (cell != Cell.EMPTY && cell != Cell.OBSTRUCTION) {
                    count++;
                }
            }
        }
        return count;
    }

    public static int puzzle2(char[][] grid) {
        Position guardPosition = findGuardPosition(grid);
        char[][] originalGrid = deepCopy(grid);

        // Get visited positions from original path
        predictGuardMovement(grid);
        Set<Position> visitedPositions = new HashSet<>();

        for (int i = 0; i < grid.length; i++) {
            for (int j = 0; j < grid[0].length; j++) {
                if (grid[i][j] != Cell.EMPTY && grid[i][j] != Cell.OBSTRUCTION) {
                    visitedPositions.add(new Position(i, j));
                }
            }
        }

        // Remove guard's starting position
        visitedPositions.remove(new Position(guardPosition.x, guardPosition.y));

        // Try putting obstruction at each visited position
        int loopCount = 0;

        for (Position pos : visitedPositions) {
            if (originalGrid[pos.x][pos.y] != Cell.EMPTY) continue;

            char[][] testGrid = deepCopy(originalGrid);
            testGrid[pos.x][pos.y] = Cell.OBSTRUCTION;

            if (createsLoop(testGrid)) {
                loopCount++;
            }
        }

        return loopCount;
    }

    private static char[][] readInput() throws IOException {
        List<String> lines = Files.readAllLines(Paths.get(INPUT_PATH));
        char[][] grid = new char[lines.size()][];
        for (int i = 0; i < lines.size(); i++) {
            grid[i] = lines.get(i).toCharArray();
        }
        return grid;
    }

    private static boolean predictGuardMovement(char[][] grid) {
        int directionIndex = 0;
        Set<Position> visitedPositions = new HashSet<>();
        Position guard = findGuardPosition(grid);

        while (true) {
            visitedPositions.add(new Position(guard.x, guard.y, directionIndex));
            grid[guard.x][guard.y] = directionToArrow(directionIndex);

            int newX = guard.x + DIRECTIONS[directionIndex][0];
            int newY = guard.y + DIRECTIONS[directionIndex][1];

            // Check boundaries
            if (isOutOfBounds(newX, newY, grid)) {
                return false;
            }

            // Check for loops
            if (visitedPositions.contains(new Position(newX, newY, directionIndex))) {
                return true;
            }

            if (grid[newX][newY] == Cell.OBSTRUCTION) {
                directionIndex = (directionIndex + 1) % 4;
            } else {
                guard.x = newX;
                guard.y = newY;
            }
        }
    }

    private static Position findGuardPosition(char[][] grid) {
        for (int i = 0; i < grid.length; i++) {
            for (int j = 0; j < grid[0].length; j++) {
                if (grid[i][j] == Cell.GUARD) {
                    return new Position(i, j);
                }
            }
        }
        return null;
    }

    private static boolean isOutOfBounds(int x, int y, char[][] grid) {
        return x < 0 || x >= grid.length || y < 0 || y >= grid[0].length;
    }

    private static char directionToArrow(int direction) {
        switch (direction) {
            case 0: return Cell.VISITED_UP;
            case 1: return Cell.VISITED_RIGHT;
            case 2: return Cell.VISITED_DOWN;
            case 3: return Cell.VISITED_LEFT;
            default: throw new IllegalArgumentException("Invalid direction");
        }
    }

    private static boolean createsLoop(char[][] grid) {
        char[][] testGrid = deepCopy(grid);
        return predictGuardMovement(testGrid);
    }

    private static char[][] deepCopy(char[][] original) {
        char[][] copy = new char[original.length][];
        for (int i = 0; i < original.length; i++) {
            copy[i] = Arrays.copyOf(original[i], original[i].length);
        }
        return copy;
    }
}

