package day2;

import java.io.IOException;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.Scanner;
import java.util.stream.IntStream;

public class Day2 {
    public static final String INPUT_PATH = "../../../../inputs/day2/input.txt";

    public static void main(String[] args) {
        System.out.println(puzzle1());
        System.out.println(puzzle2());
    }

    public static int puzzle1() {
        try (Scanner scanner = new Scanner(Paths.get(INPUT_PATH))) {
            return (int) scanner.useDelimiter("\n")
                .tokens()
                .map(line -> line.split(" "))
                .filter(reports -> {
                    int[] numbers = Arrays.stream(reports)
                        .mapToInt(Integer::parseInt)
                        .toArray();
                    
                    // Check first difference to determine direction
                    boolean isIncreasing = numbers[1] > numbers[0];
                    
                    return IntStream.range(1, numbers.length)
                        .allMatch(i -> {
                            int diff = numbers[i] - numbers[i-1];
                            // Check if direction matches and difference is valid
                            return (isIncreasing && diff > 0 && diff <= 3) ||
                                   (!isIncreasing && diff < 0 && diff >= -3);
                        });
                })
                .count();
        } catch (IOException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public static int puzzle2() {
        try (Scanner scanner = new Scanner(Paths.get(INPUT_PATH))) {
            return (int) scanner.useDelimiter("\n")
                .tokens()
                .map(line -> line.split(" "))
                .filter(reports -> {
                    int[] numbers = Arrays.stream(reports)
                        .mapToInt(Integer::parseInt)
                        .toArray();

                    if (isSafeReport(numbers)){
                        return true;
                    } 
                    
                    return IntStream.range(0, numbers.length)
                        .anyMatch(skip_index -> {
                            int[] test_numbers = new int[numbers.length - 1];
                            System.arraycopy(numbers, 0, test_numbers, 0, skip_index);
                            System.arraycopy(numbers, skip_index + 1, test_numbers, skip_index, numbers.length - skip_index - 1);
                            return isSafeReport(test_numbers);
                        });
                })
                .count();
        } catch (IOException e) {
            e.printStackTrace();
            return 0;
        }
    }

    private static boolean isSafeReport(int[] numbers) {
        boolean isIncreasing = numbers[1] > numbers[0];

        return IntStream.range(1, numbers.length)
            .allMatch(i -> {
                int diff = numbers[i] - numbers[i-1];
                return (isIncreasing && diff >= 1 && diff <= 3) || (!isIncreasing && diff <= -1 && diff >= -3);
            });
    }
}
