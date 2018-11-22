//
//  LastFmApi.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import Foundation

class LastFmApi {
    
    // MARK: - Private variables

    fileprivate var proto: String?
    fileprivate var domain: String?
    fileprivate var apiKey: String?

    // MARK: - Private backing variables
    
    fileprivate var stringUtility: StringUtility!
    fileprivate var dictionaryUtility: DictionaryUtility!
    fileprivate var httpClient: HttpClient!

    // MARK: - Setters and getters
    
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

    private func getHttpClient() -> HttpClient {
        if httpClient != nil {
            return httpClient
        }
        
        httpClient = HttpClient()
        
        return httpClient
    }

    func setPrototype(proto: String) {
        self.proto = proto
    }
    
    func setDomain(domain: String) {
        self.domain = domain
    }

    func setApiKey(apiKey: String) {
        self.apiKey = apiKey
    }

    // MARK: - LastFmApi methods
    
    func search(parameters: [String:Any], completion: @escaping ([String:Any]?) -> Void) {
        guard getStringUtility().hasValue(string: proto) && getStringUtility().hasValue(string: domain) && getStringUtility().hasValue(string: apiKey) else {
            completion(nil)
            
            return
        }
        
        var httpRequest: [String:Any] = [:]
        injectApiParameters(httpRequest: &httpRequest)
        
        httpRequest[KeyValue.methodKey] = KeyValue.getValue as Any
        var query: String = ""
        
        if let method = getDictionaryUtility().getString(dictionary: parameters, key: "method") {
            query = String(format: "method=%@.search&", method)
            
            if let search = getDictionaryUtility().getString(dictionary: parameters, key: "search") {
                let encoded = search.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
                query = String(format: "%@%@=%@&", query, method, encoded!)
            }
        }
        
        if let page = getDictionaryUtility().getInt(dictionary: parameters, key: "page") {
            query = String(format: "%@page=%d&", query, page)
        }
        
        if let limit = getDictionaryUtility().getInt(dictionary: parameters, key: "limit") {
            query = String(format: "%@limit=%d&", query, limit)
        }
        
        let rel = String(format: "2.0/?%@api_key=%@&format=json", query, apiKey!)
        httpRequest[KeyValue.relKey] = rel as Any
        httpRequest[KeyValue.responseContentTypeKey] = KeyValue.dictionaryValue as Any
        getHttpClient().execute(httpRequest: httpRequest, completion: { response in
            completion(response)
        })
    }

    func getInfo(parameters: [String:Any], completion: @escaping ([String:Any]?) -> Void) {
        guard getStringUtility().hasValue(string: proto) && getStringUtility().hasValue(string: domain) && getStringUtility().hasValue(string: apiKey) else {
            completion(nil)
            return
        }

        var httpRequest: [String:Any] = [:]
        injectApiParameters(httpRequest: &httpRequest)
        
        httpRequest[KeyValue.methodKey] = KeyValue.getValue as Any
        var query: String = ""
        
        if let method = getDictionaryUtility().getString(dictionary: parameters, key: "method") {
            query = String(format: "method=%@.getinfo&", method)
        }
        
        if let mbid = getDictionaryUtility().getString(dictionary: parameters, key: "mbid") {
            query = String(format: "%@mbid=%@&", query, mbid)
        }
        
        let rel = String(format: "2.0/?%@api_key=%@&format=json", query, apiKey!)
        httpRequest[KeyValue.relKey] = rel as Any
        httpRequest[KeyValue.responseContentTypeKey] = KeyValue.dictionaryValue as Any
        getHttpClient().execute(httpRequest: httpRequest, completion: { response in
            completion(response)
        })
    }

    func getTopAlbums(parameters: [String:Any], completion: @escaping ([String:Any]?) -> Void) {
        guard getStringUtility().hasValue(string: proto) && getStringUtility().hasValue(string: domain) && getStringUtility().hasValue(string: apiKey) else {
            completion(nil)
            
            return
        }
        
        var httpRequest: [String:Any] = [:]
        injectApiParameters(httpRequest: &httpRequest)
        
        httpRequest[KeyValue.methodKey] = KeyValue.getValue as Any
        var query: String = ""
        
        if let mbid = getDictionaryUtility().getString(dictionary: parameters, key: "mbid") {
            query = String(format: "mbid=%@&", mbid)
        }
        
        if let page = getDictionaryUtility().getInt(dictionary: parameters, key: "page") {
            query = String(format: "%@page=%d&", query, page)
        }
        
        if let limit = getDictionaryUtility().getInt(dictionary: parameters, key: "limit") {
            query = String(format: "%@limit=%d&", query, limit)
        }
        
        let rel = String(format: "2.0/?method=artist.gettopalbums&%@api_key=%@&format=json", query, apiKey!)
        httpRequest[KeyValue.relKey] = rel as Any
        httpRequest[KeyValue.responseContentTypeKey] = KeyValue.dictionaryValue as Any
        getHttpClient().execute(httpRequest: httpRequest, completion: { response in
            completion(response)
        })
    }

    func downloadData(url: String, completion: @escaping (Data?) -> Void) {
        let executeHttpRequest = ExecuteHttpRequest()
        let url = URL(string: url)
        
        guard url != nil else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url:url!)
        executeHttpRequest.executeRequest(request: urlRequest) { (statusCode, data) in

            if statusCode != nil && statusCode == 200 {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }

    fileprivate func injectApiParameters(httpRequest: inout [String:Any]) {
        guard getStringUtility().hasValue(string: proto) && getStringUtility().hasValue(string: domain) else {
            return
        }
        
        httpRequest[KeyValue.protocolKey] = proto as Any
        httpRequest[KeyValue.domainKey] = domain as Any
    }

}
