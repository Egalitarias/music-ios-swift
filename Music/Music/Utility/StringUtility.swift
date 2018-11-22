//
//  StringUtility.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import Foundation

class StringUtility {
    
    // MARK: - StringUtility methods

    func hasValue(string: String?) -> Bool {
        if let stringObject = string {
            return stringObject.count > 0
        } else {
            return false
        }
    }
    
    func areEqual(string: String?, other: String?) -> Bool {
        guard string != nil && other != nil else { return false }
        
        return string!.compare(other!) == .orderedSame
    }

    func toInt(string: String?) -> Int? {
        guard string != nil else { return nil }
        
        if string!.count > 0 {
            let value = Int(string!)
            
            return value
        }
        
        return nil
    }
    
    func concatenate(string: String?, other: String?) -> String? {
        if !hasValue(string: string) && !hasValue(string: other) { return nil }
        
        if !hasValue(string: string) {
            return other
        }
        
        if !hasValue(string: other) {
            return string
        }

        let concat = String(format: "%@%@", string!, other!)
        
        return concat
    }

    func matchesPattern(string: String?, pattern: String?) -> Bool {
        guard hasValue(string: string) && hasValue(string: pattern) else { return false }
        
        do {
            let regex = try NSRegularExpression(pattern: pattern!)
            let results = regex.matches(in: string!, range: NSRange(string!.startIndex..., in: string!))
            let matches = results.map {
                String(string![Range($0.range, in: string!)!])
            }
            
            if(matches.count == 1) {
                return areEqual(string: matches[0], other: string)
            } else {
                return false
            }
        } catch _ {
            return false
        }
    }

    func split(string: String?, delimiter: String?) -> [String]? {
        guard hasValue(string: string) && hasValue(string: delimiter) else { return nil }
        
        let parts = string!.components(separatedBy: delimiter!)
        
        return parts
    }

    func lastComponent(string: String?) -> String? {
        guard string != nil else { return nil }
        
        let last = (string! as NSString).lastPathComponent
        
        return last
    }
    
    func removeHtmlTag(string: String?, tag: String?) -> String? {
        guard string != nil && tag != nil else { return nil }

        return string!.replacingOccurrences(of: "(?i)</?\(tag!)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
}
