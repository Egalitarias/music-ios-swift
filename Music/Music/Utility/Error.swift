//
//  Error.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import Foundation

class Error {
    
    // MARK: - Error methods
    
    func makeError(message: String) -> [String:Any] {
        var error: [String:Any] = [:]
        error[KeyValue.errorKey] = message as Any
        print("Error: \(message)")
        
        return error
    }
    
}
