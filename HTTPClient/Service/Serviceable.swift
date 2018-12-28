//
//  Serviceable.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

public protocol Serviceable {
    
    /// 服务器基础路径
    var baseUrl: String { get }
}

extension Serviceable {
    
    var url: URL {
        return URL(string: baseUrl)!
    }
}
