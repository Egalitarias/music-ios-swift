//
//  Json.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import Foundation

class Json {
    
    fileprivate static let stringPairFormat = "\"%@\":\"%@\""
    fileprivate static let AnyPairFormat = "\"%@\":%@"
    fileprivate static let bool = "Bool"
    fileprivate static let boolTruePairFormat = "\"%@\":true"
    fileprivate static let boolFalsePairFormat = "\"%@\":false"
    fileprivate static let nullPairFormat = "\"%@\":null"
    fileprivate static let bracesFormat = "{%@}"
    fileprivate static let emptyDictionary = "{}"
    fileprivate static let stringFormat = "\"%@\""
    fileprivate static let AnyFormat = "%@"
    fileprivate static let boolTrueFormat = "true"
    fileprivate static let boolFalseFormat = "false"
    fileprivate static let nullFormat = "null"
    fileprivate static let bracketsFormat = "[%@]"
    fileprivate static let emptyArray = "[]"
    
    // MARK: - Private backing variables

    fileprivate var stringUtility: StringUtility!
    fileprivate var dictionaryUtility: DictionaryUtility!
    fileprivate var arrayUtility: ArrayUtility!
    fileprivate var error: Error!

    // MARK: - Setters and getters

    private func getStringUtility() -> StringUtility {
        if stringUtility != nil {
            return stringUtility
        }
        
        stringUtility = StringUtility()
        
        return stringUtility
    }

    private func getError() -> Error {
        if error != nil {
            return error
        }
        
        error = Error()
        
        return error
    }

    private func getDictionaryUtility() -> DictionaryUtility {
        if dictionaryUtility != nil {
            return dictionaryUtility
        }
        
        dictionaryUtility = DictionaryUtility()
        
        return dictionaryUtility
    }
    
    private func getArrayUtility() -> ArrayUtility {
        if arrayUtility != nil {
            return arrayUtility
        }
        
        arrayUtility = ArrayUtility()
        
        return arrayUtility
    }

    func dictionaryToJson(dictionary: [String:Any]?) -> String? {
        let json = convertDictionaryToJson(dictionary: dictionary)
        
        return json
    }
    
    func arrayToJson(array: [Any]?) -> String? {
        let json = convertArrayToJson(array: array)
        
        return json
    }

    func jsonToDictionary(json: String?) -> [String:Any]? {
        guard getStringUtility().hasValue(string: json) else {
            return nil
        }
        
        do {

            if let data = json!.data(using: String.Encoding.utf8) {
                let any = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
                
                if let dictionary = any as? [String : Any] {
                    
                    return dictionary
                }
            }
        } catch let error as NSError {
            let _ = getError().makeError(message: error.localizedDescription)
        }
        
        return nil
    }

    func jsonToArray(json: String?) -> [Any]? {
        guard getStringUtility().hasValue(string: json) else {
            return nil
        }

        do {
            
            if let data = json!.data(using: String.Encoding.utf8) {
                let any = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
                
                if let array = any as? [Any] {
                    
                    return array
                }
            }
        } catch let error as NSError {
            let _ = getError().makeError(message: error.localizedDescription)
        }
        
        return nil
    }

    fileprivate func convertDictionaryToJson(dictionary: [String:Any]?) -> String? {
        guard getDictionaryUtility().hasValues(dictionary: dictionary) else {
            return nil
        }
        
        var json: String?
        
        for key in dictionary!.keys {
            
            if let value = dictionary![key] {
                
                if let string = value as? String {
                    let pair = String(format: Json.stringPairFormat, key, string)
                    json = appendJsonPair(json: json, pair: pair)
                } else if let innerDictionary = value as? [String:Any] {
                    
                    if let dictionaryJson = convertDictionaryToJson(dictionary: innerDictionary) {
                        let pair = String(format: Json.AnyPairFormat, key, dictionaryJson)
                        json = appendJsonPair(json: json, pair: pair)
                    }
                } else if let innerArray = value as? [Any] {
                    
                    if let arrayJson = convertArrayToJson(array: innerArray) {
                        let pair = String(format: Json.AnyPairFormat, key, arrayJson)
                        json = appendJsonPair(json: json, pair: pair)
                    }
                } else {
                    let dynamicTypeString = String(describing: type(of: value))
                    
                    if(dynamicTypeString.contains(Json.bool)) {
                        
                        if let bool = value as? Bool {
                            
                            if(bool) {
                                let pair = String(format: Json.boolTruePairFormat, key)
                                json = appendJsonPair(json: json, pair: pair)
                            } else {
                                let pair = String(format: Json.boolFalsePairFormat, key)
                                json = appendJsonPair(json: json, pair: pair)
                            }
                        }
                    } else {
                        
                        if let number = value as? NSNumber {
                            let pair = String(format: Json.AnyPairFormat, key, String(describing: number))
                            json = appendJsonPair(json: json, pair: pair)
                        } else {
                            let pair = String(format: Json.nullPairFormat, key)
                            json = appendJsonPair(json: json, pair: pair)
                        }
                    }
                }                
            }
        }
        
        if let jsonObject = json {
            let jsonDictionary = String(format: Json.bracesFormat, jsonObject)
            
            return jsonDictionary
        } else {
            return Json.emptyDictionary
        }
    }
    
    fileprivate func convertArrayToJson(array: [Any]?) -> String? {
        guard getArrayUtility().hasValues(array: array) else {
            return nil
        }
        
        var json: String?
        
        for value in array! {
            
            if let string = value as? String {
                let pair = String(format: Json.stringFormat, string)
                json = appendJsonPair(json: json, pair: pair)
            } else if let innerDictionary = value as? [String:Any] {
                
                if let dictionaryJson = convertDictionaryToJson(dictionary: innerDictionary) {
                    let pair = String(format: Json.AnyFormat, dictionaryJson)
                    json = appendJsonPair(json: json, pair: pair)
                }
            } else if let innerArray = value as? [Any] {
                
                if let arrayJson = convertArrayToJson(array: innerArray) {
                    let pair = String(format: Json.AnyFormat, arrayJson)
                    json = appendJsonPair(json: json, pair: pair)
                }
            } else {
                let dynamicTypeString = String(describing: type(of: value))
                
                if dynamicTypeString.contains(Json.bool) {
                    
                    if let bool = value as? Bool {
                        
                        if bool {
                            let pair = String(format: Json.boolTrueFormat)
                            json = appendJsonPair(json: json, pair: pair)
                        } else {
                            let pair = String(format: Json.boolFalseFormat)
                            json = appendJsonPair(json: json, pair: pair)
                        }
                    }
                } else {
                    
                    if let number = value as? NSNumber {
                        let pair = String(format: Json.AnyFormat, String(describing: number))
                        json = appendJsonPair(json: json, pair: pair)
                    } else {
                        let pair = String(format: Json.nullFormat)
                        json = appendJsonPair(json: json, pair: pair)
                    }
                }
            }
        }
        
        if let jsonObject = json {
            let jsonArray = String(format: Json.bracketsFormat, jsonObject)
            
            return jsonArray
        } else {
            
            return Json.emptyArray
        }
    }

    fileprivate func appendJsonPair(json: String?, pair: String) -> String {
        if let jsonObject = json {
            
            return String(format: "%@,%@", jsonObject, pair)
        } else {
            
            return pair
        }
    }
}
