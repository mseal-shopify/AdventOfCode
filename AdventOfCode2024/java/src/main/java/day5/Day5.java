package day5;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Map;
import java.util.Set;
import java.util.List;
import java.util.Arrays;
import java.util.Collections;
import java.util.stream.Collectors;
import java.nio.file.Files;
import java.nio.file.Path;

public class Day5 {
    public static final String INPUT_PATH = "../../../../inputs/day5/input.txt";
    public static final Map<Integer, Set<Integer>> rules = new HashMap<>();

    public static void main(String[] args) throws IOException {
        String input = Files.readString(Path.of(INPUT_PATH));
        String[] sections = input.split("\n\n");

        String[] rulesSection = sections[0].split("\n");
        String[] updatesSection = sections[1].split("\n");

        parseRules(rulesSection);

        System.out.println(puzzle1(updatesSection));
        System.out.println(puzzle2(updatesSection));
    }

    public static int puzzle1(String[] updatesSection) {
        int midSum = 0;

        for (String update : updatesSection) {
            List<Integer> pages = Arrays.stream(update.split(","))
                .map(Integer::parseInt)
                .collect(Collectors.toList());

            if (isValidUpdate(pages)) {
                int midIndex = (pages.size() - 1) / 2;
                midSum += pages.get(midIndex);
            }
        }

        return midSum;
    }

    public static int puzzle2(String[] updatesSection) {
        int midSum = 0;

        for (String update : updatesSection) {
            List<Integer> pages = Arrays.stream(update.split(","))
                .map(Integer::parseInt)
                .collect(Collectors.toList());

            if (!isValidUpdate(pages)) {
                reorderPages(pages);
                int midIndex = (pages.size() - 1) / 2;
                midSum += pages.get(midIndex);
            }
        }

        return midSum;
    }

    public static void parseRules(String[] rulesSection) {
        for (String rule : rulesSection) {
            String[] parts = rule.split("\\|");
            int page1 = Integer.parseInt(parts[0]);
            int page2 = Integer.parseInt(parts[1]);

            rules.computeIfAbsent(page1, k -> new HashSet<>()).add(page2);
        }
    }

    public static boolean isValidUpdate(List<Integer> pages) {
        for (int i = 0; i < pages.size() - 1; i++) {
            int currentPage = pages.get(i);
            int nextPage = pages.get(i + 1);

            if (!rules.get(currentPage).contains(nextPage)) {
                return false;
            }
        }

        return true;
    }

    public static void reorderPages(List<Integer> pages) {
        int n = pages.size();

        while (true) {
            boolean swapped = false;

            for (int i = 0; i < n - 1; i++) {
                if (!rules.get(pages.get(i)).contains(pages.get(i + 1))) {
                    Collections.swap(pages, i, i + 1);
                    swapped = true;
                }
            }

            if (!swapped) {
                break;
            }
        }
    }
}

