//
//  ResponseValidator.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

public protocol ResponseValidator {
    
    /// 校验数据，并返回期望的数据类型
    ///
    /// - Parameter response: 请求返回数据
    /// - Returns: 目标数据
    /// - Throws: 校验相关错误信息
    func validate(_ response: Response) throws -> Any
}

