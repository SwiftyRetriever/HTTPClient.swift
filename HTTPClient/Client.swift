//
//  Client.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias SessionManager = Alamofire.SessionManager

// Request
public typealias Request = Alamofire.Request
public typealias DataRequest = Alamofire.DataRequest

// Upload
public typealias UploadRequest = Alamofire.UploadRequest
public typealias AFMultipartFormData = Alamofire.MultipartFormData

// Download
public typealias DownloadRequest = Alamofire.DownloadRequest
public typealias DownloadDestination = Alamofire.DownloadRequest.DownloadFileDestination

// ParameterEncoding
public typealias ParameterEncoding = Alamofire.ParameterEncoding
public typealias JSONEncoding = Alamofire.JSONEncoding
public typealias URLEncoding = Alamofire.URLEncoding

// Results
public typealias DataResponseSerializerProtocol = Alamofire.DataResponseSerializerProtocol
public typealias AFResult = Alamofire.Result
public typealias Timeline = Alamofire.Timeline

public protocol Client: AnyObject {
    
    associatedtype R: Requestable
    
    /// 发送一个网络请求
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 完成回调
    /// - Returns: 请求任务
    func send(request: R, queue: DispatchQueue?, progressHandler: ProgressHandler?, completionHandler: @escaping (CompletionHandler)) -> Task?
    
    /// 发起一个Alamofire.DownloadRequest
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - destination: 目标路径处理回调
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 完成回调
    /// - Returns: 请求任务
    func downlown(request: R, destination: DownloadDestination?, queue: DispatchQueue?, progressHandler: ProgressHandler?, completionHandler: @escaping (CompletionHandler)) -> Task?
    
    /// 根据文件URL，上传一个文件到服务器
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - fileURL: 文件路径URL
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 完成回调
    /// - Returns: 请求任务
    func upload(request: R, fileURL: URL, queue: DispatchQueue?, progressHandler: ProgressHandler?, completionHandler: @escaping (CompletionHandler)) -> Task?
    
    /// 上传Multipart数据
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - mutipartFormData: Multipart 数据
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 完成回调
    /// - Returns: 请求任务
    func upload(request: R, mutipartFormData: [MultipartFormData], queue: DispatchQueue?, progressHandler: ProgressHandler?, completionHandler: @escaping (CompletionHandler)) -> Task?
}

