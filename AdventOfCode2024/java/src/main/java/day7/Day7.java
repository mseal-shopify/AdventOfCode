package day7;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

public class Day7 {
    public static final String INPUT_PATH = "../../../../inputs/day7/input.txt";

    public static long puzzle1() throws IOException {
        List<String> input = Files.readAllLines(Paths.get(INPUT_PATH));
        
        long totalCalibrationResult = 0;
        for (String line : input) {
            String[] parts = line.split(":");
            long target = Long.parseLong(parts[0].trim());
            long[] numbers = Arrays.stream(parts[1].trim().split("\\s+"))
                                .mapToLong(Long::parseLong)
                                .toArray();
            
            if (canMakeValue(numbers, target, null, null)) {
                totalCalibrationResult += target;
            }
        }
        
        return totalCalibrationResult;
    }

    public static long puzzle2() throws IOException {
        List<String> input = Files.readAllLines(Paths.get(INPUT_PATH));
        
        long totalCalibrationResult = 0;
        for (String line : input) {
            String[] parts = line.split(":");
            long target = Long.parseLong(parts[0].trim());
            long[] numbers = Arrays.stream(parts[1].trim().split("\\s+"))
                                .mapToLong(Long::parseLong)
                                .toArray();
            
            if (canMakeValueV2(numbers, target, null, null)) {
                totalCalibrationResult += target;
            }
        }
        
        return totalCalibrationResult;
    }

    private static boolean canMakeValue(long[] numbers, long target, Long currentValue, long[] remainingNumbers) {
        // Initial setup on first call
        if (remainingNumbers == null) {
            if (numbers.length == 0) return false;
            remainingNumbers = Arrays.copyOfRange(numbers, 1, numbers.length);
            currentValue = numbers[0];
        }

        // Base case: if no more numbers and current value equals target
        if (remainingNumbers.length == 0) {
            return currentValue == target;
        }

        long nextNum = remainingNumbers[0];
        long[] nextRemaining = Arrays.copyOfRange(remainingNumbers, 1, remainingNumbers.length);

        // Try addition
        if (canMakeValue(numbers, target, currentValue + nextNum, nextRemaining)) {
            return true;
        }

        // Try multiplication
        if (canMakeValue(numbers, target, currentValue * nextNum, nextRemaining)) {
            return true;
        }

        // If neither operation works, return false
        return false;
    }

    private static boolean canMakeValueV2(long[] numbers, long target, Long currentValue, long[] remainingNumbers) {
        // Initial setup on first call
        if (remainingNumbers == null) {
            if (numbers.length == 0) return false;
            remainingNumbers = Arrays.copyOfRange(numbers, 1, numbers.length);
            currentValue = numbers[0];
        }

        // Base case: if no more numbers and current value equals target
        if (remainingNumbers.length == 0) {
            return currentValue == target;
        }

        long nextNum = remainingNumbers[0];
        long[] nextRemaining = Arrays.copyOfRange(remainingNumbers, 1, remainingNumbers.length);

        // Try addition
        if (canMakeValueV2(numbers, target, currentValue + nextNum, nextRemaining)) {
            return true;
        }

        // Try multiplication
        if (canMakeValueV2(numbers, target, currentValue * nextNum, nextRemaining)) {
            return true;
        }

        // Try concatenation
        String concatenated = String.valueOf(currentValue) + String.valueOf(nextNum);
        if (canMakeValueV2(numbers, target, Long.parseLong(concatenated), nextRemaining)) {
            return true;
        }

        // If no operation works, return false
        return false;
    }

    public static void main(String[] args) throws IOException {
        System.out.println(puzzle1());
        System.out.println(puzzle2());
    }
} 