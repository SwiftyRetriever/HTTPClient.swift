//
//  Builder.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

internal final class Builder<R: Requestable> {
    
    private let request: R
    
    init(_ request: R) {
        self.request = request
    }
    
    func build() throws -> URLRequest {
        
        guard let url = URL(string: request.path, relativeTo: request.service.url) else {
            throw HTTPError.invalidUrl(service: request.service.baseUrl,
                                       path: request.path)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        request.headers?.forEach { (headerField, headerValue) in
            urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
        
        let params = try request.intercept(paramters: request.parameters)
        
        do {
            try request.inspect(paramters: params)
        } catch {
            throw HTTPError.invalidParameters(service: request.service.baseUrl,
                                              path: request.path,
                                              paramters: request.parameters,
                                              error: error)
        }
        
        var encoding: ParameterEncoding
        switch request.formatter {
        case .json:
            encoding = JSONEncoding.default
        case .url:
            encoding = URLEncoding.default
        }
        
        urlRequest = try encoding.encode(urlRequest, with: params)
        urlRequest = try request.intercept(request: urlRequest)
        
        return urlRequest
    }
    
    func build(_ errorHandler: (Error) -> Void) -> URLRequest? {
        
        var urlRequest: URLRequest?
        do {
            urlRequest = try build()
        } catch let error {
            errorHandler(error)
        }
        
        return urlRequest
    }
}

