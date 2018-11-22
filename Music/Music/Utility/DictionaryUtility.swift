//
//  DictionaryUtility.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import Foundation

class DictionaryUtility {
    
    // MARK: - Private backing variables

    fileprivate var stringUtility: StringUtility!
    fileprivate var json: Json!

    // MARK: - Getters and setters
    
    private func getStringUtility() -> StringUtility {
        if stringUtility != nil {
            return stringUtility
        }
        
        stringUtility = StringUtility()
        
        return stringUtility
    }

    private func getJson() -> Json {
        if json != nil {
            return json
        }
        
        json = Json()
        
        return json
    }

    // MARK: - DictionaryUtility methods

    func hasValues(dictionary: [String:Any]?) -> Bool {
        return dictionary != nil && dictionary!.count > 0
    }

    func hasStringValue(dictionary: [String:Any]?, key: String?, value: String?) -> Bool {
        let dictionaryValue = getString(dictionary: dictionary, key: key)
        let has = getStringUtility().areEqual(string: value, other: dictionaryValue)
        
        return has
    }

    func hasIntValue(dictionary: [String:Any]?, key: String?, value: Int?) -> Bool {
        guard value != nil else { return false }
        
        let dictionaryValue = getInt(dictionary: dictionary, key: key)
        let has = dictionaryValue != nil && dictionaryValue! == value!
        
        return has
    }

    func hasKey(dictionary: [String:Any]?, key: String?) -> Bool {
        guard hasValues(dictionary: dictionary) && getStringUtility().hasValue(string: key) else { return false }
        
        let has = dictionary?.keys.contains(key!)
        
        return has!
    }

    func getInt(dictionary: [String:Any]?, key: String?) -> Int? {
        guard hasValues(dictionary: dictionary) && getStringUtility().hasValue(string: key) else { return nil }
        
        let object = dictionary![key!]
        
        if(object is Int) {
            let integer = object as? Int
            
            return integer
        }
        
        return nil
    }
    
    func getFloat(dictionary: [String:Any], key: String) -> Float? {
        guard key.count != 0 else { return nil }
        guard dictionary[key] != nil else { return nil }
        
        let object = dictionary[key]
        
        if(object is Float) {
            let float = object as? Float
            
            return float
        }
        
        return nil
    }

    func getDouble(dictionary: [String:Any]?, key: String?) -> Double? {
        guard hasValues(dictionary: dictionary) && getStringUtility().hasValue(string: key) else { return nil }
        
        let object = dictionary![key!]
        
        if(object is Double) {
            let double = object as? Double
            
            return double
        }
        
        return nil
    }

    func getString(dictionary: [String:Any]?, key: String?) -> String? {
        guard hasValues(dictionary: dictionary) && getStringUtility().hasValue(string: key) else { return nil }
        
        let string = dictionary![key!] as? String
        
        return string
    }
    
    func getBool(dictionary: [String:Any]?, key: String?) -> Bool? {
        guard hasValues(dictionary: dictionary) && getStringUtility().hasValue(string: key) else { return nil }
        
        if let bool = dictionary![key!] as? Bool {
            return bool
        }
        
        return nil
    }

    func getFlatField(dictionary: [String:Any], key: String) -> Any? {
        if let any = getInt(dictionary: dictionary, key: key) {
            return any as Any
        }

        if let any = getFloat(dictionary: dictionary, key: key) {
            return any as Any
        }

        if let any = getDouble(dictionary: dictionary, key: key) {
            return any as Any
        }

        if let any = getString(dictionary: dictionary, key: key) {
            return any as Any
        }

        if let any = getBool(dictionary: dictionary, key: key) {
            return any as Any
        }

        return nil
    }
    
    func getDictionary(dictionary: [String:Any]?, key: String?) -> [String:Any]? {
        guard hasValues(dictionary: dictionary) && getStringUtility().hasValue(string: key) else { return nil }
        
        let innerDictionary = dictionary![key!] as? [String:Any]
        
        return innerDictionary
        
    }
    
    func getStringDictionary(dictionary: [String:Any]?, key: String?) -> [String:String]? {
        if let innerDictionary = getDictionary(dictionary: dictionary, key: key) {
            let stringDictionary = convertDictionaryToStringDictionary(dictionary: innerDictionary)
            
            return stringDictionary
        }
        
        return nil
    }

    func convertDictionaryToStringDictionary(dictionary: [String:Any]) -> [String:String] {
        var stringDictionary: [String:String] = [:]
        
        for key in dictionary.keys {
            
            if let value = getString(dictionary: dictionary, key: key) {
                stringDictionary[key] = value
            }
        }
        
        return stringDictionary
    }
    
    fileprivate func getDictionaryByKeyAndIntValue(array: [Any], key: String, value: Int) -> [String:Any]? {
        
        for any in array {
                    
            if let innerDictionary = any as? [String:Any] {
                        
                if let id = getInt(dictionary: innerDictionary, key: key) {
                            
                    if(id == value) {
                        return innerDictionary
                    }
                }
            }
        }
        
        return nil
    }

    func getArray(dictionary: [String:Any]?, key: String?) -> [Any]? {
        guard hasValues(dictionary: dictionary) && getStringUtility().hasValue(string: key) else { return nil }
        
        guard dictionary![key!] != nil else { return nil }
        
        let object = dictionary![key!]
        
        if(object is [Any]) {
            let innerArray = object as? [Any]
            return innerArray
        }
        
        return nil
    }

    func getStringArray(dictionary: [String:Any]?, key: String?) -> [String]? {
        var stringArray: [String]? = nil
        
        if let array = getArray(dictionary: dictionary, key: key) {
            
            for item in array {
                
                if let itemString = item as? String {
                    
                    if stringArray == nil {
                        stringArray = []
                    }
                    
                    stringArray?.append(itemString)
                }
            }
        }
        
        return stringArray
    }
    
    func convertStringDictionary(dictionary: [String:Any]?) -> [String:String]? {
        guard dictionary != nil else { return nil }
        
        var stringDictionary: [String:String] = [:]
        
        for (key, value) in dictionary! {
                
            if value is String {
                let valueString = value as! String
                stringDictionary[key] = valueString
            }
        }
        
        return stringDictionary
    }
    
    func convertDictionaryToStringAnyDictionary(dictionary: NSMutableDictionary?) -> [String:Any]? {
        if let dictionaryObject = dictionary {
            var stringAnyDictionary: [String:Any] = [:]
            
            for key in dictionaryObject.allKeys {
                
                if let keyString = key as? String {
                    stringAnyDictionary[keyString] = dictionaryObject[keyString] as Any
                }
            }
            
            return stringAnyDictionary
        } else {
            return nil
        }
    }

    func convertStringAnyDictionaryToDictionary(stringAnyDictionary: [String:Any]?) -> NSMutableDictionary? {
        if let stringAnyDictionaryObject = stringAnyDictionary {
            let dictionary = NSMutableDictionary()

            for key in stringAnyDictionaryObject.keys {
                dictionary.setValue(stringAnyDictionaryObject[key], forKey: key)
            }
            
            return dictionary
        } else {
            return nil
        }
    }
    
    func debug(dictionary: [String:Any]?) {
        guard hasValues(dictionary: dictionary) else {
            print("nil")
            
            return
        }
        
        let json = getJson().dictionaryToJson(dictionary: dictionary!)
        print(json ?? "nil")
    }

}
