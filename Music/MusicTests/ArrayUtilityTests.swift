//
//  ArrayUtilityTests.swift
//  MusicTests
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import XCTest
@testable import Music

class ArrayUtilityTests: XCTestCase {
    
    fileprivate var arrayUtility: ArrayUtility?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        arrayUtility = ArrayUtility()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        arrayUtility = nil
    }
    
    // MARK: - ArrayUtility hasValues()
    
    func testHasValuesForNilReturnsFalse() {
        // Arrange
        let array: [Any]? = nil
        
        // Act
        let result = arrayUtility?.hasValues(array: array)
        
        // Assert
        XCTAssertFalse(result!)
    }

    func testHasValuesForEmptyReturnsFalse() {
        // Arrange
        let array: [Any]? = []

        // Act
        let result = arrayUtility?.hasValues(array: array)
        
        // Assert
        XCTAssertFalse(result!)
    }
    
    func testHasValuesForValuesReturnsTrue() {
        // Arrange
        var array: [Any]? = []
        array?.append("value")
        
        // Act
        let result = arrayUtility?.hasValues(array: array)
        
        // Assert
        XCTAssertTrue(result!)
    }

    // MARK: - ArrayUtility getString()

    func testGetStringForEmptyReturnsNil() {
        // Arrange
        let array: [Any]? = []
        
        // Act
        let result = arrayUtility?.getString(array: array, index: 0)
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testGetStringForWithStringReturnsString() {
        // Arrange
        var array: [Any]? = []
        array?.append("value")
        
        // Act
        let result = arrayUtility?.getString(array: array, index: 0)
        
        // Assert
        XCTAssertEqual(result, "value")
    }

    // MARK: - ArrayUtility getDictionaryByIntQuery()
    
    func testGetDictionaryByIntQueryForEmptyReturnsNil() {
        // Arrange
        let array: [Any]? = []
        
        // Act
        let result = arrayUtility?.getDictionaryByIntQuery(array: array, key: "key", value: 29)
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testGetDictionaryByIntQueryForDictionaryReturnsDictionary() {
        // Arrange
        var array: [Any]? = []
        var dictionary: [String:Any] = [:]
        dictionary["key"] = 29
        array?.append(dictionary)
        
        // Act
        let result = arrayUtility?.getDictionaryByIntQuery(array: array, key: "key", value: 29)
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 1)
    }
    
    // MARK: - ArrayUtility getDictionaryByStringQuery()
    
    func testGetDictionaryByStringQueryForEmptyReturnsNil() {
        // Arrange
        let array: [Any]? = []
        
        // Act
        let result = arrayUtility?.getDictionaryByStringQuery(array: array!, key: "key", value: "value")
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testGetDictionaryByStringQueryForDictionaryReturnsDictionary() {
        // Arrange
        var array: [Any]? = []
        var dictionary: [String:Any] = [:]
        dictionary["key"] = "value"
        array?.append(dictionary)
        
        // Act
        let result = arrayUtility?.getDictionaryByStringQuery(array: array!, key: "key", value: "value")
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 1)
    }
    
    // MARK: - ArrayUtility filterArrayByString()
    
    func testFilterArrayByStringForEmptyReturnsEmpty() {
        // Arrange
        let array: [Any]? = []
        
        // Act
        let result = arrayUtility?.filterArrayByString(array: array!, key: "key", value: "value")
        
        // Assert
        XCTAssertEqual(result?.count, 0)
    }
    
    func testFilterArrayByStringForDictionaryReturnsFiltered() {
        // Arrange
        var array: [Any]? = []
        var dictionary1: [String:Any] = [:]
        dictionary1["key"] = "value"
        array?.append(dictionary1)
        var dictionary2: [String:Any] = [:]
        dictionary2["other"] = "bye"
        array?.append(dictionary2)

        // Act
        let result = arrayUtility?.filterArrayByString(array: array!, key: "key", value: "value")
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 1)
    }

}
