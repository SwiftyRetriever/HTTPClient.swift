//
//  Client.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Foundation
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



public enum RequestType {
    case data
    case download(destination: Destination?)
    case uploadFile(fileURL: URL)
    case uploadFormData(mutipartFormData: [MultipartFormData])
}

public protocol Client: AnyObject {
    
    associatedtype R: Requestable
    
    /// 发送一个网络请求
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - requestType: 请求类型
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 完成回调
    /// - Returns: 请求任务
    func send(request: R, requestType: RequestType, queue: DispatchQueue?, progressHandler: ProgressHandler?, completionHandler: @escaping (CompletionHandler)) -> Task?

}

