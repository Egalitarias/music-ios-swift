//
//  DictionaryUtilityTests.swift
//  MusicTests
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import XCTest
@testable import Music

class DictionaryUtilityTests: XCTestCase {
    
    fileprivate var dictionaryUtility: DictionaryUtility?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dictionaryUtility = DictionaryUtility()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        dictionaryUtility = nil
    }
    
    // MARK: - DictionaryUtility hasValues()

    func testHasValuesForNilReturnsFalse() {
        // Arrange
        let dictionary: [String:Any]? = nil
        
        // Act
        let result = dictionaryUtility?.hasValues(dictionary: dictionary)
        
        // Assert
        XCTAssertFalse(result!)
    }

    func testHasValuesForEmptyReturnsFalse() {
        // Arrange
        let dictionary: [String:Any] = [:]
        
        // Act
        let result = dictionaryUtility?.hasValues(dictionary: dictionary)
        
        // Assert
        XCTAssertFalse(result!)
    }

    func testHasValuesForValuesReturnsTrue() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["first"] = "first"

        // Act
        let result = dictionaryUtility?.hasValues(dictionary: dictionary)
        
        // Assert
        XCTAssertTrue(result!)
    }

    // MARK: - DictionaryUtility hasStringValue()

    func testHasStringValueForDictionaryWithoutStringValueReturnsFalse() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["first"] = "first"
        
        // Act
        let result = dictionaryUtility?.hasStringValue(dictionary: dictionary, key: "key", value: "value")
        
        // Assert
        XCTAssertFalse(result!)
    }

    func testHasStringValueForDictionaryWithStringValueReturnsTrue() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["key"] = "value"
        
        // Act
        let result = dictionaryUtility?.hasStringValue(dictionary: dictionary, key: "key", value: "value")
        
        // Assert
        XCTAssertTrue(result!)
    }

    // MARK: - DictionaryUtility hasIntValue()
    
    func testHasIntValueForDictionaryWithoutIntValueReturnsFalse() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["first"] = "first"
        
        // Act
        let result = dictionaryUtility?.hasIntValue(dictionary: dictionary, key: "key", value: 5)
        
        // Assert
        XCTAssertFalse(result!)
    }
    
    func testHasIntValueForDictionaryWithIntValueReturnsTrue() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["key"] = 5
        
        // Act
        let result = dictionaryUtility?.hasIntValue(dictionary: dictionary, key: "key", value: 5)
        
        // Assert
        XCTAssertTrue(result!)
    }

    // MARK: - DictionaryUtility hasKey()
    
    func testHasKeyForDictionaryWithoutKeyReturnsFalse() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["first"] = "first"
        
        // Act
        let result = dictionaryUtility?.hasKey(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertFalse(result!)
    }
    
    func testHasKeyForDictionaryWithKeyReturnsTrue() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["key"] = 5
        
        // Act
        let result = dictionaryUtility?.hasKey(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertTrue(result!)
    }
    
    // MARK: - DictionaryUtility getInt()

    func testGetIntForDictionaryWithoutIntValueReturnsNil() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["first"] = "first"
        
        // Act
        let result = dictionaryUtility?.getInt(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertNil(result)
    }

    func testGetIntForDictionaryWithIntValueReturnsInt() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["key"] = 11
        
        // Act
        let result = dictionaryUtility?.getInt(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertEqual(result, 11)
    }

    // MARK: - DictionaryUtility getFloat()
    
    func testGetFloatForDictionaryWithoutFloatValueReturnsNil() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["first"] = "first"
        
        // Act
        let result = dictionaryUtility?.getFloat(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testGetFloatForDictionaryWithFloatValueReturnsFloat() {
        // Arrange
        var dictionary: [String:Any] = [:]
        let value: Float = 16.0
        dictionary["key"] = value
        
        // Act
        let result = dictionaryUtility?.getFloat(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertEqual(result, value)
    }

    // MARK: - DictionaryUtility getDouble()
    
    func testGetDoubleForDictionaryWithoutFloatValueReturnsNil() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["first"] = "first"
        
        // Act
        let result = dictionaryUtility?.getDouble(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testGetDoubleForDictionaryWithDoubleValueReturnsFloat() {
        // Arrange
        var dictionary: [String:Any] = [:]
        let value: Double = 16.0
        dictionary["key"] = value
        
        // Act
        let result = dictionaryUtility?.getDouble(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertEqual(result, value)
    }

    // MARK: - DictionaryUtility getString()
    
    func testGetDoubleForDictionaryWithoutStringReturnsNil() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["first"] = "first"
        
        // Act
        let result = dictionaryUtility?.getString(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testGetDoubleForDictionaryWithStringValueReturnsDouble() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["key"] = "value"
        
        // Act
        let result = dictionaryUtility?.getString(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertEqual(result, "value")
    }

    // MARK: - DictionaryUtility getBool()
    
    func testGetBoolForDictionaryWithoutBoolReturnsNil() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["first"] = "first"
        
        // Act
        let result = dictionaryUtility?.getBool(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testGetBoolForDictionaryWithStringValueReturnsBool() {
        // Arrange
        var dictionary: [String:Any] = [:]
        dictionary["key"] = true
        
        // Act
        let result = dictionaryUtility?.getBool(dictionary: dictionary, key: "key")
        
        // Assert
        XCTAssertTrue(result!)
    }

}
