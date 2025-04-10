//
//  PrimeNumbers.swift
//
//  Created by Zak Goneau
//  Created on 2025-04-09
//  Version 1.0
//  Copyright (c) 2025 Zak Goneau. All rights reserved.
//
//  Search for prime numbers using files.

// Import library
import Foundation

// Declare max size for array
let SIZE = 10

// Declare constants for random number generation
let MIN = 1
let MAX = 100

// Function definition to find prime numbers
func checkPrime(array: [Int]) -> [Int] {
    // Initialize an empty array to store prime numbers
    var resultList: [Int] = []

    // Loop through array of numbers
    for number in array {

        // Check if number is 0
        if number == 0 {
            // Skip to next iteration
            continue

        // Check if number is 1
        } else if number == 1 {
            // Skip to next iteration
            continue
        
        // Otherwise check if number is prime
        } else {
            // Set flag to true
            var isPrime = true

            // Loop through numbers
            for counter in 2..<number {
                if number % counter == 0  {
                isPrime = false
                break
                }
            }

            // If prime, add to the list
            if isPrime {
                resultList.append(number)
            }
        }
    }

    // Return the list of prime numbers
    return resultList
}

// Main function
func main() {
    // Declare file names
    let numberFile = "numbers.txt"
    let outputFile = "output.txt"

    // Initialize output string
    var outputStr = ""

    // Initialize an empty array to store lines
    var randomLines: [String] = []

    // Introduce program to user
    print("This program searches for prime numbers.")

    // Generate 5 lines of random numbers
    for _ in 0..<5 {
        // Initialize an empty string for the line
        var line = ""

        // Loop to generate random numbers
        for i in 0..<SIZE {
            // Generate a random number
            let randomNum = Int.random(in: MIN...MAX)

            // Add number to line
            line += String(randomNum)

            // Add space as long as number isn't last
            if i < SIZE - 1 {
                line += " "
            }
        }
        // Append the line to the array
        randomLines.append(line)
    }

    // Write to numbers.txt file
    let allLines = randomLines.joined(separator: "\n")
    do {
        try allLines.write(toFile: numberFile, atomically: true, encoding: .utf8)

    // Tell user if it couldn't write to file
    } catch {
        print("Couldn't write to file")
        // Exit program
        exit(1)
    }

    // Read from numbers.txt
    var fileLines: [String] = []
    do {
        let fileContents = try String(contentsOfFile: numberFile, encoding: .utf8)
        fileLines = fileContents.components(separatedBy: "\n")
    
    // Tell user if it couldn't read from file
    } catch {
        print("Couldn't read the file")
        // Exit program
        exit(1)
    }

    // Process each line
    var lineIndex = 0

    // Loop while there are lines to process
    while lineIndex < fileLines.count {
        // Trim the line to remove whitespace and newlines
        let line = fileLines[lineIndex].trimmingCharacters(in: .whitespacesAndNewlines)

        // Split the line into string numbers
        let stringNumbers = line.components(separatedBy: " ")

        // Initialize an empty array to store integers
        var numberArray: [Int] = []

        // Loop through string numbers and convert to integers
        for stringNum in stringNumbers {

            // Cast string to int
            if let intNum = Int(stringNum) {

                // Append to number array
                numberArray.append(intNum)
            }
        }

        // Sort the array using bubble sort
        for pass in 0..<numberArray.count {
            // Loop through the array
            for counter in 0..<numberArray.count - pass - 1 {

                // Compare adjacent numbers
                if numberArray[counter] > numberArray[counter + 1] {

                    // Set larger number to temp
                    let temp = numberArray[counter]

                    // Swap the numbers
                    numberArray[counter] = numberArray[counter + 1]
                    numberArray[counter + 1] = temp
                }
            }
        }

        // Print the sorted array
        print("Sorted Line \(lineIndex + 1): \(numberArray)")
        outputStr += "Sorted Line \(lineIndex + 1): \(numberArray)\n"

        // Find prime numbers in the sorted array
        let primes = checkPrime(array: numberArray)

        // Print the prime numbers
        print("Prime Numbers in Line \(lineIndex + 1): \(primes)")
        outputStr += "Prime Numbers in Line \(lineIndex + 1): \(primes)\n"

        // Increment line index
        lineIndex += 1
    }

    // Ask user for a number
    print("Enter a number to search for: ")

    // Try to read user input
    guard let input = readLine(), let searchNum = Int(input) else {

        // Tell user invalid input if failed conversion
        print("Invalid input.")
        // Return from function
        return
    }

    // Initialize search line
    var searchLine = 0

    // Initialize flag for if number is found
    var found = false

    // Loop while there are lines to search
    while searchLine < fileLines.count {
        // Trim the line to remove whitespace and newlines
        let line = fileLines[searchLine].trimmingCharacters(in: .whitespacesAndNewlines)

        // Split the line into string numbers
        let stringNumbers = line.components(separatedBy: " ")

        // Initialize an empty array to store integers
        var intArray: [Int] = []

        // Loop through string numbers and convert to integers
        for numStr in stringNumbers {

            // Cast string to int
            if let num = Int(numStr) {

                // Append to int array
                intArray.append(num)
            }
        }

        // Sort array
        intArray.sort()

        // Initialize binary search variables
        var low = 0
        var high = intArray.count - 1

        // initialize found index
        var foundIndex = -1

        // Perform binary search
        while low <= high {
            // Calculate mid index
            let mid = (low + high) / 2

            // Check if the number is at the midpoint
            if intArray[mid] == searchNum {

                // Set index to midpoint index
                foundIndex = mid
                // Break form loop
                break

            // Check if the number is less than the midpoint
            } else if searchNum < intArray[mid] {
                // Set high to mid - 1
                high = mid - 1

            // Otherwise, the number is greater than the midpoint
            } else {
                // Set low to mid + 1
                low = mid + 1
            }
        }

        // Check if the number was found
        if foundIndex != -1 {
            // Add to output string
            outputStr += "\(searchNum) first found in line \(searchLine + 1) at index \(foundIndex)\n"
            // Set found to true
            found = true
            // Break from loop
            break
        }

        // Increment search line
        searchLine += 1
    }

    // If search number was not found
    if !found {
        // Add to output string
        outputStr += "\(searchNum) not found in any line.\n"
    }

    // Write final results to output.txt
    do {
        try outputStr.write(toFile: outputFile, atomically: true, encoding: .utf8)
    
    // Tell user if it couldn't write to file
    } catch {
        print("Couldn't write to output file")
        exit(1)
    }
}

// Call main
main()
