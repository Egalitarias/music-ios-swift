//
//  StringUtilityTests.swift
//  Last FmTests
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import XCTest
@testable import Music

class StringUtilityTests: XCTestCase {
    
    fileprivate var stringUtility: StringUtility?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        stringUtility = StringUtility()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        stringUtility = nil
    }

    // MARK - StringUtility hasValue()
    
    func testHasValueForNilReturnsFalse() {
        // Arrange
        let string: String? = nil
        
        // Act
        let result = stringUtility?.hasValue(string: string)
        
        // Assert
        XCTAssertFalse(result!)
    }

    func testHasValueForEmptyStringReturnsFalse() {
        // Arrange
        let string: String? = ""
        
        // Act
        let result = stringUtility?.hasValue(string: string)
        
        // Assert
        XCTAssertFalse(result!)
    }

    func testHasValueForStringReturnsTrue() {
        // Arrange
        let string = "Some string"
        
        // Act
        let result = stringUtility?.hasValue(string: string)
        
        // Assert
        XCTAssert(result!)
    }

    // MARK - StringUtility areEqual()

    func testAreEqualForNilReturnsFalse() {
        // Arrange
        let string1: String? = nil
        let string2: String? = nil

        // Act
        let result = stringUtility?.areEqual(string: string1, other: string2)
        
        // Assert
        XCTAssertFalse(result!)
    }
    
    func testAreEqualForEmptyStringsReturnsTrue() {
        // Arrange
        let string1 = ""
        let string2  = ""
        
        // Act
        let result = stringUtility?.areEqual(string: string1, other: string2)
        
        // Assert
        XCTAssert(result!)
    }
    
    func testAreEqualForDifferentStringsReturnsFalse() {
        // Arrange
        let string1 = "some text"
        let string2 = "different"
        
        // Act
        let result = stringUtility?.areEqual(string: string1, other: string2)
        
        // Assert
        XCTAssertFalse(result!)
    }

    func testAreEqualForEqualStringsReturnsFalse() {
        // Arrange
        let string1 = "same"
        let string2 = "same"
        
        // Act
        let result = stringUtility?.areEqual(string: string1, other: string2)
        
        // Assert
        XCTAssert(result!)
    }

    // MARK - StringUtility toInt()

    func testToIntReturnsInt() {
        // Arrange
        let string = "3"
        
        // Act
        let result = stringUtility?.toInt(string: string)
        
        // Assert
        XCTAssertEqual(result, 3)
    }

    // MARK - StringUtility concatenate()

    func testConcatenateNilsReturnsNil() {
        // Arrange
        let string1: String? = nil
        let string2: String? = nil

        // Act
        let result = stringUtility?.concatenate(string: string1, other: string2)
        
        // Assert
        XCTAssertNil(result)
    }

    func testConcatenateStringsReturnsConcatenated() {
        // Arrange
        let string1 = "hello"
        let string2 = " world"
        
        // Act
        let result = stringUtility?.concatenate(string: string1, other: string2)
        
        // Assert
        XCTAssertEqual(result, "hello world")
    }
    
    // MARK - StringUtility split()

    func testSplitStringReturnsSplits() {
        // Arrange
        let string = "first,second,third"
        let delimiter = ","
        
        // Act
        let result = stringUtility?.split(string: string, delimiter: delimiter)
        
        // Assert
        XCTAssertEqual(result?.count, 3)
        XCTAssertEqual(result?[0], "first")
        XCTAssertEqual(result?[1], "second")
        XCTAssertEqual(result?[2], "third")
    }

    // MARK - StringUtility lastComponent()

    func testLastComponentReturnsLastComponent() {
        // Arrange
        let string = "api/v2/song"
        
        // Act
        let result = stringUtility?.lastComponent(string: string)
        
        // Assert
        XCTAssertEqual(result, "song")
    }
}
