//
//  Client.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.

import Result

public typealias ProgressHandler = (Progress) -> Void
public typealias CompletionHandler = (Result<Response, HTTPError>) -> Void

public enum RequestType {
    case data
    case download(destination: Destination?)
    case uploadFile(fileURL: URL)
    case uploadFormData(mutipartFormData: [MultipartFormData])
}

public protocol Client: AnyObject {
    
    // swiftlint:disable:next type_name
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
    // swiftlint:disable:next line_length
    func send(request: R, requestType: RequestType, queue: DispatchQueue?, progressHandler: ProgressHandler?, completionHandler: @escaping (CompletionHandler)) -> Task?

}
