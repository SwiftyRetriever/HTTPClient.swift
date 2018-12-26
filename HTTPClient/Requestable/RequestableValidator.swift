//
//  RequestableValidator.swift
//  HTTPClient
//
//  Created by zevwings on 2018/12/26.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Foundation

// MARK: - RequestableValidator
public protocol RequestableValidator {
    
    /// 校验类型，校验返回的status code 是否为正确的值，默认校验正确和重定向code
    var validationType: ValidationType { get }
    
    /// 校验请求参数是否满足服务器要求
    ///
    /// - Parameter paramters: 参数
    /// - Throws: 参数校验异常
    func validate(paramters: Parameters?) throws
}

public extension RequestableValidator {
    
    public var validationType: ValidationType {
        return .none
    }
    
    func validate(paramters: Parameters?) throws {
        
    }
}
