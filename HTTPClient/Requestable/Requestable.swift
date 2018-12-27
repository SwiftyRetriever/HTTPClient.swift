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
    var headerFields: HTTPHeaders? { get }

}

// MARK: - Defaults
extension Requestable {
    
    public var headerFields: [String: String]? {
        return nil
    }
}
