//
//  HTTPClient.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

public final class HTTPClient<R: Requestable>: Client {
    
    public let manager: SessionManager
    
    public init(manager: SessionManager = HTTPClient.defaultAlamofireManager()) {
        self.manager = manager
    }
    
    /// 发送一个Alamofire.DataRequest
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 完成回调
    /// - Returns: 请求任务
    @discardableResult
    public func request(request: R,
                        queue: DispatchQueue? = .main,
                        progressHandler: ProgressHandler? = nil,
                        completionHandler: @escaping (CompletionHandler))
        -> Task? {
            return send(request: request,
                        requestType: .data,
                        queue: queue,
                        progressHandler: progressHandler,
                        completionHandler: completionHandler)
    }
    
    /// 发起一个Alamofire.DownloadRequest
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - destination: 目标路径处理回调
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 完成回调
    /// - Returns: 请求任务
    @discardableResult
    public func downlown(request: R,
                         to destination: Destination? = nil,
                         queue: DispatchQueue? = .main,
                         progressHandler: ProgressHandler?,
                         completionHandler: @escaping (CompletionHandler))
        -> Task? {
            return send(request: request,
                        requestType: .download(destination: destination),
                        queue: queue,
                        progressHandler: progressHandler,
                        completionHandler: completionHandler)
    }
    
    /// 根据文件URL，上传一个文件到服务器
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - fileURL: 文件路径URL
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 完成回调
    /// - Returns: 请求任务
    @discardableResult
    public func upload(request: R,
                       fileURL: URL,
                       queue: DispatchQueue? = .main,
                       progressHandler: ProgressHandler? = nil,
                       completionHandler: @escaping (CompletionHandler))
        -> Task? {
            return send(request: request,
                        requestType: .uploadFile(fileURL: fileURL),
                        queue: queue,
                        progressHandler: progressHandler,
                        completionHandler: completionHandler)
    }
    
    /// 上传Multipart数据
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - mutipartFormData: Multipart 数据
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    ///   - completionHandler: 完成回调
    /// - Returns: 请求任务
    @discardableResult
    public func upload(request: R,
                       mutipartFormData: [MultipartFormData],
                       queue: DispatchQueue? = .main,
                       progressHandler: ProgressHandler? = nil,
                       completionHandler: @escaping (CompletionHandler))
        -> Task? {
            return send(request: request,
                        requestType: .uploadFormData(mutipartFormData: mutipartFormData),
                        queue: queue,
                        progressHandler: progressHandler,
                        completionHandler: completionHandler)
    }
    
    public func send(request: R,
                     requestType: RequestType,
                     queue: DispatchQueue?,
                     progressHandler: ProgressHandler?,
                     completionHandler: @escaping (CompletionHandler)) -> Task? {
        do {
            let alamofireRequest = try buildAlamofireRequest(request, requestType: requestType, queue: queue)
            return sendAlamofireRequest(alamofireRequest,
                                        request: request,
                                        queue: queue,
                                        progressHandler: progressHandler,
                                        completionHandler: completionHandler)
        } catch let error as HTTPError {
            completionHandler(.failure(error))
            return nil
        } catch let error {
            let err = HTTPError.request(service: request.service.baseUrl, path: request.path, error: error)
            completionHandler(.failure(err))
            return nil
        }
    }
}
