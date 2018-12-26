//
//  Configration.swift
//  HTTPClient
//
//  Created by zevwings on 2018/12/26.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Alamofire

// Public
public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias SessionManager = Alamofire.SessionManager
public typealias Timeline = Alamofire.Timeline
public typealias Destination = Alamofire.DownloadRequest.DownloadFileDestination

// Request
internal typealias Request = Alamofire.Request
internal typealias DataRequest = Alamofire.DataRequest
internal typealias UploadRequest = Alamofire.UploadRequest
internal typealias DownloadRequest = Alamofire.DownloadRequest
internal typealias AFMultipartFormData = Alamofire.MultipartFormData

// ParameterEncoding
internal typealias ParameterEncoding = Alamofire.ParameterEncoding
internal typealias JSONEncoding = Alamofire.JSONEncoding
internal typealias URLEncoding = Alamofire.URLEncoding

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

