//
//  ExecuteHttpRequest.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import Foundation

class ExecuteHttpRequest {
    
    func executeRequest(request: URLRequest?, completion: ((Int?, Data?) -> Void)?) {
        guard request != nil else {
            if(completion != nil) {
                completion!(nil, nil)
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: request!) { (data, response, error) in
            if(error == nil) {
                var statusCode: Int? = nil
                
                if let httpResponse = response as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                
                if(completion != nil) {
                    completion!(statusCode, data)
                }
            } else {
                if(completion != nil) {
                    completion!(nil, nil)
                }
            }
        }

        task.resume();
    }

}
