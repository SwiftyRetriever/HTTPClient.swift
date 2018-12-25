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
public typealias AFRequest = Alamofire.Request
public typealias AFDataRequest = Alamofire.DataRequest

// Upload
public typealias AFUploadRequest = Alamofire.UploadRequest
public typealias AFMultipartFormData = Alamofire.MultipartFormData

// Download
public typealias AFDownloadRequest = Alamofire.DownloadRequest
public typealias AFDownloadDestination = Alamofire.DownloadRequest.DownloadFileDestination

// ParameterEncoding
public typealias AFParameterEncoding = Alamofire.ParameterEncoding
public typealias AFJSONEncoding = Alamofire.JSONEncoding
public typealias AFURLEncoding = Alamofire.URLEncoding

// Results
public typealias AFDataResponseSerializerProtocol = Alamofire.DataResponseSerializerProtocol
public typealias AFResult = Alamofire.Result
public typealias AFTimeline = Alamofire.Timeline

public enum RequestType {
    case request
    case download(destination: AFDownloadDestination?)
    case upload(fileURL: URL)
    case upload(mutipartFormData: [MultipartFormData])
}

public protocol Client: AnyObject {
    
    associatedtype R: Requestable
    
    func send(request: R, task: RequestType, queue: DispatchQueue?, progressHandler: ProgressHandler?, completionHandler: @escaping (CompletionHandler)) -> Task?
    
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
    func downlown(request: R, destination: AFDownloadDestination?, queue: DispatchQueue?, progressHandler: ProgressHandler?, completionHandler: @escaping (CompletionHandler)) -> Task?
    
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

