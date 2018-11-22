//
//  HttpClient.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import Foundation

class HttpClient {
    
    // MARK: - Constants
    
    fileprivate static let statusCodeOk = 200
    fileprivate static let statusCodeRedirect = 300
    fileprivate static let statusCodeClientError = 400
    fileprivate static let statusCodeServerError = 500
    fileprivate static let stausCodeBadRequest = 400
    
    // MARK: - Private backing variables

    fileprivate var error: Error!
    fileprivate var executeHttpRequest: ExecuteHttpRequest!
    fileprivate var json: Json!
    fileprivate var stringUtility: StringUtility!
    fileprivate var dictionaryUtility: DictionaryUtility!

    // MARK: - Setters and getters
    
    private func getError() -> Error {
        if error != nil {
            return error
        }
        
        error = Error()
        
        return error
    }

    private func getExecuteHttpRequest() -> ExecuteHttpRequest {
        if executeHttpRequest != nil {
            return executeHttpRequest
        }
        
        executeHttpRequest = ExecuteHttpRequest()
        
        return executeHttpRequest
    }
    
    private func getJson() -> Json {
        if json != nil {
            return json
        }
        
        json = Json()
        
        return json
    }
    
    private func getStringUtility() -> StringUtility {
        if stringUtility != nil {
            return stringUtility
        }
        
        stringUtility = StringUtility()
        
        return stringUtility
    }

    private func getDictionaryUtility() -> DictionaryUtility {
        if dictionaryUtility != nil {
            return dictionaryUtility
        }
        
        dictionaryUtility = DictionaryUtility()
        
        return dictionaryUtility
    }

    // MARK: - HttpClient methods
    
    func execute(httpRequest: [String:Any], completion: @escaping ([String:Any]?) -> Void) {
        let method = getDictionaryUtility().getString(dictionary: httpRequest, key: KeyValue.methodKey)
        guard getStringUtility().hasValue(string: method) else {
            let response = getError().makeError(message: "Missing method")
            completion(response)
            
            return
        }

        switch(method) {
            case KeyValue.getValue:
                get(httpRequest: httpRequest, completion: completion)
                break
            case KeyValue.postValue:
                post(httpRequest: httpRequest, completion: completion)
                break
            default:
                let response = getError().makeError(message: "Missing method")
                completion(response)
        }
    }

    func responseIsStatusCodeIsSuccess(response: [String:Any]?) -> Bool {
        if let responseObject = response {
            
            if let statusCodeObject = getDictionaryUtility().getInt(dictionary: responseObject, key: KeyValue.statusCodeKey) {
                return statusCodeObject >= HttpClient.statusCodeOk && statusCodeObject < HttpClient.statusCodeRedirect
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func responseIsStatusCodeIsBadRequest(response: [String:Any]?) -> Bool {
        if let responseObject = response {
            
            if let statusCodeObject = getDictionaryUtility().getInt(dictionary: responseObject, key: KeyValue.statusCodeKey) {
                return statusCodeObject == HttpClient.stausCodeBadRequest
            } else {
                return false
            }
        } else {
            return false
        }
    }

    func responseIsDuplicateRecordFound(response: [String:Any]?) -> Bool {
        guard response != nil else {
            return false
        }
        
        let statusCode = getDictionaryUtility().getInt(dictionary: response!, key: KeyValue.statusCodeKey)
        
        guard statusCode != nil else {
            return false
        }
        
        if statusCode != HttpClient.stausCodeBadRequest {
            return false
        }
        
        let content = getDictionaryUtility().getDictionary(dictionary: response!, key: KeyValue.contentKey)
        
        guard content != nil else {
            return false
        }
        
        let record = getDictionaryUtility().getArray(dictionary: content!, key: KeyValue.recordKey)
        
        guard record != nil else {
            return false
        }
        
        guard record!.count >= 1 else {
            return false
        }

        let string = record!.first as? String
        
        guard string != nil else {
            return false
        }
        
        let isDuplicateRecordFound = string!.contains("Record validation failed: Duplicate record found")
            
        return isDuplicateRecordFound
    }
    
    func responseIsStatusCodeIsClientError(response: [String:Any]?) -> Bool {
        if let responseObject = response {
            
            if let statusCodeObject = getDictionaryUtility().getInt(dictionary: responseObject, key: KeyValue.statusCodeKey) {
                return statusCodeObject >= HttpClient.statusCodeClientError && statusCodeObject < HttpClient.statusCodeServerError
            } else {
                return false
            }
        } else {
            return false
        }
    }

    fileprivate func get(httpRequest: [String:Any], completion: @escaping ([String:Any]?) -> Void) {
        let requestParameters = getDictionaryUtility().getDictionary(dictionary: httpRequest, key: KeyValue.requestParametersKey)
        let uri = makeUri(requestParameters: httpRequest, queryParameters: requestParameters)
        
        if let uriValue = uri {
            var request = URLRequest(url: URL(string: uriValue)!)
            request.httpMethod = "GET"

            if let authorizationValue = getDictionaryUtility().getString(dictionary: httpRequest, key: KeyValue.authorizationKey) {
                request.addValue(authorizationValue, forHTTPHeaderField: KeyValue.authorizationKey)
            }
            
            getExecuteHttpRequest().executeRequest(request: request, completion: { (statusCode, data) in
                var response:[String:Any] = [:]
                
                if statusCode != nil {
                    response[KeyValue.statusCodeKey] = statusCode! as Any
                }
                
                if data != nil {
                    let string = String(data: data!, encoding: String.Encoding.utf8)
                    
                    if string != nil {
                        let json = Json()
                        let dictionary = json.jsonToDictionary(json: string!)
                        
                        if dictionary != nil {
                            response[KeyValue.contentKey] = dictionary! as Any
                        }
                    }
                }
                
                completion(response)
            })
        } else {
            completion(nil)
        }
    }
    
    fileprivate func post(httpRequest: [String:Any], completion: @escaping ([String:Any]?) -> Void) {
        let requestParameters = getDictionaryUtility().getDictionary(dictionary: httpRequest, key: KeyValue.requestParametersKey)
        let uri = makeUri(requestParameters: httpRequest, queryParameters: nil)
        
        if let uriValue = uri {
            var request = URLRequest(url: URL(string: uriValue)!)
            request.httpMethod = "POST"
            
            if let authorizationValue = getDictionaryUtility().getString(dictionary: httpRequest, key: KeyValue.authorizationKey) {
                request.addValue(authorizationValue, forHTTPHeaderField: "authorization")
            }

            let dictionary = httpRequest[KeyValue.dictionaryKey] as? [String:Any]

            if dictionary != nil {
                let fileName = dictionary![KeyValue.fileNameKey] as? String
                let data = dictionary![KeyValue.dataKey] as? Data
                let type = dictionary![KeyValue.typeKey] as? String

                if fileName != nil && data != nil && type != nil {
                    var record: [String: String] = [:]
                    record[KeyValue.recordKey] = dictionary![KeyValue.recordKey] as? String
                    record[KeyValue.fileNameKey] = dictionary![KeyValue.fileNameKey] as? String
                    record[KeyValue.typeKey] = dictionary![KeyValue.typeKey] as? String
                    let jsonData = try? JSONSerialization.data(withJSONObject: record, options: .prettyPrinted)
                    
                    if jsonData != nil {
                        request.httpBody = jsonData
                    }
                    
                    let boundary = "Boundary-\(UUID().uuidString)"
                    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    request.httpBody = createBody(parameters: record, boundary: boundary, data: data!, mimeType: "image/png", filename: fileName!)
                } else {
                    let jsonData = try? JSONSerialization.data(withJSONObject: dictionary as Any, options: .prettyPrinted)
                    
                    if jsonData != nil {
                        request.httpBody = jsonData
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
                }
            } else {
                let postQuery = makeQuery(parameters: requestParameters)
            
                if postQuery != nil {
                    request.httpBody = postQuery!.data(using: .utf8)
                }
            }
            
            getExecuteHttpRequest().executeRequest(request: request, completion: { (statusCode, data) in
                var response:[String:Any] = [:]
                
                if statusCode != nil {
                    response[KeyValue.statusCodeKey] = statusCode! as Any
                }
                
                if data != nil {
                    let string = String(data: data!, encoding: String.Encoding.utf8)
                    
                    if string != nil {
                        let json = Json()
                        let dictionary = json.jsonToDictionary(json: string!)
                        
                        if dictionary != nil {
                            response[KeyValue.contentKey] = dictionary! as Any
                        }
                    }
                }
                
                completion(response)
            })
        } else {
            completion(nil)
        }
    }
    
    func createBody(parameters: [String: String], boundary: String, data: Data, mimeType: String, filename: String) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            appendStringToData(data: &body, string: boundaryPrefix)
            appendStringToData(data: &body, string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            appendStringToData(data: &body, string: "\(value)\r\n")
        }
        
        appendStringToData(data: &body, string: boundaryPrefix)
        appendStringToData(data: &body, string: "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        appendStringToData(data: &body, string: "Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        appendStringToData(data: &body, string: "\r\n")
        appendStringToData(data: &body, string: "--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    func appendStringToData(data: inout Data, string: String) {
        data.append(Data(string.utf8))
    }
    
    func getServerResponseMessage(response: [String:Any]?) -> String? {
        guard response != nil else {
            return nil
        }
        
        let content = getDictionaryUtility().getDictionary(dictionary: response!, key: KeyValue.contentKey)
        
        guard content != nil else {
            return nil
        }
        
        let record = getDictionaryUtility().getArray(dictionary: content!, key: KeyValue.recordKey)
        
        guard record != nil else {
            return nil
        }
        
        guard record!.count >= 1 else {
            return nil
        }
        
        let message = record!.first as? String
        
        return message
    }

    // MARK: - HttpClient methods
    
    fileprivate func makeUri(requestParameters: [String:Any], queryParameters: [String:Any]?) -> String? {
        var uri: String? = nil
        let query = makeQuery(parameters: queryParameters)
        
        if let protocolValue = getDictionaryUtility().getString(dictionary: requestParameters, key: KeyValue.protocolKey) {
            
            if let domainValue = getDictionaryUtility().getString(dictionary: requestParameters, key: KeyValue.domainKey) {
                
                if let relValue = getDictionaryUtility().getString(dictionary: requestParameters, key: KeyValue.relKey) {
                    var formattedUri = String(format: "%@://%@/%@", protocolValue, domainValue, relValue)
                            
                    if let queryValue = query {
                        formattedUri = String(format: "%@?%@", formattedUri, queryValue)
                    }
                            
                    uri = formattedUri
                }
            }
        }
        
        print("uri: ", uri ?? "nil")
        return uri
    }
    
    fileprivate func makeParameters(requestParameters: [String:Any]?) -> [String:String] {
        var parameters: [String:String] = [:]
        
        if let requestParametersValue = requestParameters {
            
            for (key, value) in requestParametersValue {
                
                if value is String {
                    let valueString = value as! String

                    parameters[key] = valueString
                }
            }
        }
        
        return parameters
    }
    
    fileprivate func makeQuery(parameters: [String:Any]?) -> String? {
        var query: String? = nil

        if let parametersValue = parameters {
            
            for (key, value) in parametersValue {
                
                if value is String {
                    let valueString = value as! String
                    
                    if(query == nil) {
                        query = String(format: "%@=%@&", key, valueString)
                    } else {
                        query = String(format: "%@%@=%@&", query!, key, valueString)
                    }
                } else if value is Int {
                    let valueInt = value as! Int
                    if(query == nil) {
                        query = String(format: "%@=%d&", key, valueInt)
                    } else {
                        query = String(format: "%@%@=%d&", query!, key, valueInt)
                    }
                }
            }
        }
                
        return query
    }

}
