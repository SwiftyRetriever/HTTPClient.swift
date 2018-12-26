//
//  HTTPClient.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Result

public final class HTTPClient<R: Requestable>: Client {

    public typealias URLRequestConstractor = (Requestable) -> URLRequest?
    
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
        
        var urlRequest: URLRequest?
        do {
            let parameters = try request.intercept(paramters: request.parameters)
            let constructor = CommonConstructor(service: request.service,
                                                path: request.path,
                                                method: request.method,
                                                headerFields: request.headers,
                                                parameters: parameters,
                                                formatter: request.formatter)
            urlRequest = try constructor.urlRequest()
            urlRequest = try request.intercept(request: urlRequest!)
        } catch let error as HTTPError {
            completionHandler(.failure(error))
        } catch let error {
            let err = HTTPError.request(service: request.service.baseUrl, path: request.path, error: error)
            completionHandler(.failure(err))
        }
        
        guard let finalRequest = urlRequest else {
            return nil
        }
        
        var initalRequest: Request?
        switch requestType {
        case .data:
            initalRequest = manager.request(finalRequest)
            break
        case .download(let destination):
            initalRequest = manager.download(finalRequest, to: destination)
            break
        case .uploadFile(let fileURL):
            initalRequest = manager.upload(fileURL, with: finalRequest)
            break
        case .uploadFormData(let mutipartFormData):
            let multipartFormData: (AFMultipartFormData) -> Void = { formData in
                formData.applyMoyaMultipartFormData(mutipartFormData)
            }
            manager.upload(multipartFormData: multipartFormData, with: finalRequest, queue: queue) { result in
                switch result {
                case .success(let uploadRequest, _, _):
                    initalRequest = uploadRequest
                case .failure(let error):
                    let err = HTTPError.upload(service: request.service.baseUrl, path: request.path, error: error)
                    completionHandler(.failure(err))
                }
            }
            break
        }
        
//        sendAlamofireRequest(initalRequest!, request: request, queue: queue, progressHandler: progressHandler, completionHandler: completionHandler)
        
        return nil
    }
    
}

