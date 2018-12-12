//
//  Requestable.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

/// 网络请求头
public typealias HTTPHeaders = [String: String]

/// 网络请求参数
public typealias Parameters = [String: Any]

/// 参数格式化类型，根据格式化类型选取`Alamofire`的`ParameterEncoding`
public enum ParameterFormatter {
    case url
    case json
    /** case xml 暂时不需要支持`xml`格式 */
}

public protocol Requestable {
    
    /// 服务类型
    associatedtype Service: Serviceable
    
    /// 基础路径
    var service: Service { get }
    
    /// 请求路径
    var path: String { get }
    
    /// 请求方法
    var method: HTTPMethod { get }
    
    /// 请求参数
    var parameters: Parameters? { get }
    
    /// 参数解码方式
    var formatter: ParameterFormatter { get }
    
    /// 请求头设置，默认为 `nil`
    var headers: HTTPHeaders? { get }
    
    /// 校验类型，校验返回的status code 是否为正确的值，默认校验正确和重定向code
    var validationType: ValidationType { get }
    
    /// 校验请求参数是否满足服务器要求
    ///
    /// - Parameter paramters: 参数
    /// - Throws: 参数校验异常
    func inspect(paramters: Parameters?) throws
    
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

// MARK: - Defaults
extension Requestable {
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var validationType: ValidationType {
        return .none
    }
    
    public func inspect(paramters: Parameters?) throws {
        
    }
    
    public func intercept(paramters: Parameters?) throws -> Parameters? {
        return paramters
    }
    
    public func intercept(request: URLRequest) throws -> URLRequest {
        return request
    }
}

