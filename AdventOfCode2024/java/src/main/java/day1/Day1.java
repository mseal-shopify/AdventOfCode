package day1;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.io.IOException;
import java.util.stream.IntStream;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.HashMap;
import java.util.Map;

public class Day1 {
    public static final String INPUT_PATH = "../../../../inputs/day1/input.txt";

    public static void main(String[] args) {
        System.out.println(puzzle1());
        System.out.println(puzzle2());
    }

    public static int puzzle1() {
        int totalDistance = 0;
        
        List<Integer> leftLocations = new ArrayList<>();
        List<Integer> rightLocations = new ArrayList<>();
        
        try (Scanner scanner = new Scanner(Paths.get(INPUT_PATH))) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine().trim();
                if (!line.isEmpty()) {
                    String[] parts = line.split("\\s+");
                    leftLocations.add(Integer.parseInt(parts[0]));
                    rightLocations.add(Integer.parseInt(parts[1]));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        leftLocations.sort(Integer::compareTo);
        rightLocations.sort(Integer::compareTo);

        totalDistance = IntStream.range(0, leftLocations.size()).map(
            i -> Math.abs(leftLocations.get(i) - rightLocations.get(i))
        ).sum();
        return totalDistance;
    }

    public static int puzzle2() {
         List<Integer> leftLocations = new ArrayList<>();
        List<Integer> rightLocations = new ArrayList<>();
        
        try (Scanner scanner = new Scanner(Paths.get(INPUT_PATH))) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine().trim();
                if (!line.isEmpty()) {
                    String[] parts = line.split("\\s+");
                    leftLocations.add(Integer.parseInt(parts[0]));
                    rightLocations.add(Integer.parseInt(parts[1]));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        Map<Integer, Integer> rightLocationsMap = new HashMap<>();
        rightLocations.forEach(location -> rightLocationsMap.put(location, rightLocationsMap.getOrDefault(location, 0) + 1));

        return leftLocations.stream()
            .mapToInt(location -> location * rightLocationsMap.getOrDefault(location, 0))
            .sum();
    }
}
