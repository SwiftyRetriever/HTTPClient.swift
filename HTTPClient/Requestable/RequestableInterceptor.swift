//
//  RequestableInterceptor.swift
//  HTTPClient
//
//  Created by zevwings on 2018/12/26.
//  Copyright © 2018 zevwings. All rights reserved.
//

// MARK: - RequestableInterceptor
public protocol RequestableInterceptor {
    
    /// 拦截请求参数，可以在生成`URLRequest`之前，对参数进行修改
    ///
    /// - Parameter paramters: 请求参数
    /// - Returns: 修改后的请求参数
    func intercept(paramters: Parameters?) throws -> Parameters?
    
    /// 拦截网络请求，可以在发起网络请求之前，对`URLRequest`进行修改
    ///
    /// - Parameter request: 修改前的`URLRequest`
    /// - Returns: 修改后的`URLRequest`
    func intercept(request: URLRequest) throws -> URLRequest
    
}

public extension RequestableInterceptor {
    
    public func intercept(paramters: Parameters?) throws -> Parameters? {
        return paramters
    }
    
    public func intercept(request: URLRequest) throws -> URLRequest {
        return request
    }
}
