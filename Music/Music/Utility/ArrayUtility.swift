//
//  ArrayUtility.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

class ArrayUtility {
   
    // MARK: - Private backing variables

    fileprivate var stringUtility: StringUtility!
    fileprivate var dictionaryUtility: DictionaryUtility!
    fileprivate var json: Json!

    // MARK: - Setters and getters
    
    private func getStringUtility() -> StringUtility {
        if stringUtility != nil { return stringUtility }
        
        stringUtility = StringUtility()
        
        return stringUtility
    }
    
    private func getDictionaryUtility() -> DictionaryUtility {
        if dictionaryUtility != nil { return dictionaryUtility }
        
        dictionaryUtility = DictionaryUtility()
        
        return dictionaryUtility
    }
    
    private func getJson() -> Json {
        if json != nil { return json }
        
        json = Json()
        
        return json
    }

    // MARK: - ArrayUtility methods
    
    func hasValues(array: [Any]?) -> Bool {
        if array == nil { return false }
        
        return array!.count > 0
    }
    
    func getString(array: [Any]?, index: Int?) -> String? {
        guard array != nil && index != nil && index! < array!.count else { return nil }
        
        if let value = array![index!] as? String {
            return value
        } else {
            return nil
        }
    }
    
    func getDictionaryByIntQuery(array: [Any]?, key: String?, value: Int?) -> [String:Any]? {
        guard hasValues(array: array) else { return nil }
        
        for any in array! {
            
            if let innerDictionary = any as? [String:Any] {
                
                if let keyValue = getDictionaryUtility().getInt(dictionary: innerDictionary, key: key) {
                    
                    if(keyValue == value) {
                        return innerDictionary
                    }
                }
            }
        }
        
        return nil
    }
    
    func getDictionaryByStringQuery(array: [Any], key: String, value: String) -> [String:Any]? {
        for any in array {
            
            if let innerDictionary = any as? [String:Any] {
                
                if let keyValue = getDictionaryUtility().getString(dictionary: innerDictionary, key: key) {
                    
                    if(keyValue.compare(value) == .orderedSame) {
                        return innerDictionary
                    }
                }
            }
        }
        
        return nil
    }
    
    func filterArrayByString (array: [Any], key: String, value: String) -> [Any]? {
        var filtered: [Any] = []
        
        for item in array {
            
            if let dictionaryItem = item as? [String:Any] {
                
                if let keyValue = getDictionaryUtility().getString(dictionary: dictionaryItem, key: key) {

                    if keyValue.compare(value) == .orderedSame {
                        filtered.append(dictionaryItem as Any)
                    }
                }
            }
        }
        
        return filtered
    }
    
    func getDictionaryByHighestIntQuery(array: [Any], key: String) -> [String:Any]? {
        var highest: Int?
        var dictionary: [String:Any]?
        
        for item in array {
            
            if let itemDictionary = item as? [String:Any] {
                
                if let value = getDictionaryUtility().getInt(dictionary: itemDictionary, key: key) {
                    
                    if let highestObject = highest {
                        
                        if value > highestObject {
                            highest = value
                            dictionary = itemDictionary
                        }
                    } else {
                        highest = value
                        dictionary = itemDictionary
                    }
                }
            }
        }
        
        return dictionary
    }
    
    func getStringArray(array: [Any]?) -> [String]? {
        if(array == nil) { return nil }
        
        var stringArray: [String] = []
        
        for any in array! {
            
            if let string = any as? String {
                stringArray.append(string)
            }
        }
        
        return stringArray
    }
    
    func getStringDictionaryArray(array: [Any]?) -> [[String:String]]? {
        if array == nil { return nil }
        
        var stringDictionaryArray: [[String:String]] = []
        
        if let arrayObject = array {
            
            for any in arrayObject {
                
                if let stringDictionary = any as? [String:String] {
                    stringDictionaryArray.append(stringDictionary)
                }
            }
            
        }
        
        return stringDictionaryArray
    }
    
    func removeAtIndex(array: inout [Any]?, indexOf: Int?) {
        guard array != nil && indexOf != nil else { return }
        
        array!.remove(at: indexOf!)
    }
    
    func containsString(array: [String]?, string: String?) -> Bool {
        guard array != nil else { return false }
        
        return array!.contains { getStringUtility().areEqual(string: $0, other: string) }
    }
    
    func appendString(array: inout [String]?, string: String?) {
        guard array != nil && getStringUtility().hasValue(string: string) else { return }
        
        array?.append(string!)
    }

    func stringIndexOf(array: [String]?, string: String?) -> Int? {
        guard hasValues(array: array as [Any]?) else { return nil }
        
        return array!.index(of: string!)
    }
    
    func stringRemoveAtIndex(array: inout [String]?, indexOf: Int?) {
        guard array != nil && indexOf != nil else { return }
        
        array!.remove(at: indexOf!)
    }

    func removeString(array: inout [String]?, item: String?) {
        if let indexOf = stringIndexOf(array: array, string: item) {
            stringRemoveAtIndex(array: &array, indexOf: indexOf)
        }
    }

    func debug(array: [Any]?) {
        let json = getJson().arrayToJson(array: array)
        print(json ?? "nil")
    }

    func indexOfString(array: [String]?, string: String?) -> Int? {
        guard hasValues(array: array as [Any]?) && getStringUtility().hasValue(string: string) else { return nil }
        
        let indexOf =  array!.index(of: string!)
        
        return indexOf
    }

}
