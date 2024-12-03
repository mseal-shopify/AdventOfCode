package day3;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.regex.Pattern;
public class Day3 {

    public static final String INPUT_PATH = "../../../../inputs/day3/input.txt";
    public static final Pattern MUL_PATTERN = Pattern.compile("mul\\((?<a>-?\\d+),(?<b>-?\\d+)\\)");
    public static final Pattern DO_PATTERN = Pattern.compile("do\\(\\)");
    public static final Pattern DONT_PATTERN = Pattern.compile("don't\\(\\)");


    public static void main(String[] args) throws FileNotFoundException {
        System.out.println(puzzle1());
        System.out.println(puzzle2());
    }

    public static int puzzle1() throws FileNotFoundException {
        try (Scanner scanner = new Scanner(new File(INPUT_PATH))) {
            return scanner.findAll(MUL_PATTERN)
                    .map(match -> match.group().toString())
                    .mapToInt(Day3::parseMultiplication)
                    .sum();
        }
    }

    public static int puzzle2() throws FileNotFoundException {
        try (Scanner scanner = new Scanner(new File(INPUT_PATH))) {
            String context = scanner.useDelimiter("\\Z").next();
            return processWithInstructions(context);
        }
    }

    private static int processWithInstructions(String context) {
        int sum = 0;
        boolean enabled = true;
        int position = 0;

        while(position < context.length()) {
            var doMatcher = DO_PATTERN.matcher(context.substring(position));
            var dontMatcher = DONT_PATTERN.matcher(context.substring(position));
            var mulMatcher = MUL_PATTERN.matcher(context.substring(position));

            if (doMatcher.find() && doMatcher.start() == 0) {
                enabled = true;
                position += doMatcher.end();
            } else if (dontMatcher.find() && dontMatcher.start() == 0) {
                enabled = false;
                position += dontMatcher.end();
            } else if (mulMatcher.find() && mulMatcher.start() == 0) {
                if (enabled) {
                    sum += parseMultiplication(mulMatcher.group().toString());
                }
                position += mulMatcher.end();
            } else {
                position++;
            }
        }

        return sum;
    }


    private static int parseMultiplication(String expression) {
        try {
            String[] numbers = expression.replace("mul(", "").replace(")", "").split(",");
            int num1 = Integer.parseInt(numbers[0]);
            int num2 = Integer.parseInt(numbers[1]);
            return num1 * num2;
        } catch (Exception e) {
            return 0;
        }
    }
}
