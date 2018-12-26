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

public protocol Requestable: RequestableValidator, RequestableInterceptor {
    
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
    var headerFields: HTTPHeaders? { get }

}

// MARK: - Defaults
extension Requestable {
    
    public var headerFields: [String: String]? {
        return nil
    }
}

// MARK: - URLRequest

internal typealias ParameterHandler = ((Parameters?) -> (Parameters?))

extension Requestable {
    
    /// 生成一个可用的URLRequest
    ///
    /// - Parameter handler: 用于生成URLRequest之前拦截修改请求参数
    /// - Returns: 可用的URLRequest
    /// - Throws: 自定义
    func urlRequest(with handler: ParameterHandler) throws -> URLRequest {
        
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
        var params = try intercept(paramters: parameters)
        params = handler(params)
        urlRequest = try encoding.encode(urlRequest, with: params)
        return try intercept(request: urlRequest)
    }
}
