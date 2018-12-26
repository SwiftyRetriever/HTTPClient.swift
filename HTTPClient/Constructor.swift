//
//  Constructor.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/15.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Foundation

public protocol Constructor {
    
    var service: Serviceable { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headerFields: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var formatter: ParameterFormatter { get }
    
    func urlRequest() throws -> URLRequest
}

extension Constructor {
    
    public func urlRequest() throws -> URLRequest {
        
        guard let url = URL(string: path, relativeTo: service.url) else {
            throw HTTPError.invalidUrl(service: service.baseUrl,
                                       path: path)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        headerFields?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        var encoding: ParameterEncoding
        switch formatter {
        case .json:
            encoding = JSONEncoding.default
        case .url:
            encoding = URLEncoding.default
        }
        
        urlRequest = try encoding.encode(urlRequest, with: parameters)
        
        return urlRequest
    }

}

public class CommonConstructor: Constructor {
    
    public let service: Serviceable
    public let path: String
    public let method: HTTPMethod
    public let headerFields: HTTPHeaders?
    public let parameters: Parameters?
    public let formatter: ParameterFormatter
    
    public init(service: Serviceable,
                path: String,
                method: HTTPMethod,
                headerFields: HTTPHeaders?,
                parameters: Parameters?,
                formatter: ParameterFormatter) {
        
        self.service = service
        self.path = path
        self.method = method
        self.headerFields = headerFields
        self.parameters = parameters
        self.formatter = formatter
    }
}
