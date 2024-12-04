package day4;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

public class Day4 {
    public static final String INPUT_PATH = "../../../../inputs/day4/input.txt";

    private static final int[][] FORWARD = {{0, 0}, {0, 1}, {0, 2}, {0, 3}};
    private static final int[][] DOWN = {{0, 0}, {1, 0}, {2, 0}, {3, 0}};
    private static final int[][] BACKWARD = {{0, 0}, {0, -1}, {0, -2}, {0, -3}};
    private static final int[][] UP = {{0, 0}, {-1, 0}, {-2, 0}, {-3, 0}};
    private static final int[][] DIAGONAL_RIGHT_DOWN = {{0, 0}, {1, 1}, {2, 2}, {3, 3}};
    private static final int[][] DIAGONAL_LEFT_UP = {{0, 0}, {-1, -1}, {-2, -2}, {-3, -3}};
    private static final int[][] DIAGONAL_LEFT_DOWN = {{0, 0}, {1, -1}, {2, -2}, {3, -3}};
    private static final int[][] DIAGONAL_RIGHT_UP = {{0, 0}, {-1, 1}, {-2, 2}, {-3, 3}};

    private static final int[][][] ALL_DIRECTIONS = {
        FORWARD, DOWN, BACKWARD, UP, 
        DIAGONAL_RIGHT_DOWN, DIAGONAL_LEFT_UP, 
        DIAGONAL_LEFT_DOWN, DIAGONAL_RIGHT_UP
    };

    private static final String XMAS = "XMAS";
    private static final int[][] X_SHAPE = {{0, 0}, {-1, -1}, {1, 1}, {1, -1}, {-1, 1}};
    private static final List<String> WORDS = Arrays.asList("ASMSM", "AMSMS", "AMSSM", "ASMMS");

    public static int puzzle1(char[][] matrix) {
        int xmasCount = 0;
        int rows = matrix.length;
        int cols = matrix[0].length;

        for (int row = 0; row < rows; row++) {
            for (int col = 0; col < cols; col++) {
                for (int[][] direction : ALL_DIRECTIONS) {
                    StringBuilder word = new StringBuilder();
                    for (int[] offset : direction) {
                        int newRow = row + offset[0];
                        int newCol = col + offset[1];
                        if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
                            word.append(matrix[newRow][newCol]);
                        }
                    }
                    if (word.toString().equals(XMAS)) {
                        xmasCount++;
                    }
                }
            }
        }
        return xmasCount;
    }

    public static int puzzle2(char[][] matrix) {
        int xmasCount = 0;
        int rows = matrix.length;
        int cols = matrix[0].length;

        for (int row = 0; row < rows; row++) {
            for (int col = 0; col < cols; col++) {
                StringBuilder word = new StringBuilder();

                for (int[] offset : X_SHAPE) {
                    int newRow = row + offset[0];
                    int newCol = col + offset[1];
                    
                    if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
                        word.append(matrix[newRow][newCol]);
                    }
                }

                if (WORDS.contains(word.toString())) {
                    xmasCount++;
                }
            }
        }
        return xmasCount;
    }

    public static void main(String[] args) {
        try {
            Path path = Paths.get(INPUT_PATH);
            List<String> lines = Files.readAllLines(path);
            char[][] matrix = lines.stream()
                .map(String::toCharArray)
                .toArray(char[][]::new);

            System.out.println(puzzle1(matrix));
            System.out.println(puzzle2(matrix));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
} 