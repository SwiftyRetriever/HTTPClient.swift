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
    
    /// 构建默认的Alamofire.SessionManager
    public class func defaultAlamofireManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20.0
        configuration.timeoutIntervalForResource = 20.0
        let manager = SessionManager(configuration: configuration)
        manager.startRequestsImmediately = false
        return manager
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
        
        let urlRequest: URLRequest
        do {
            let paramInterceptor = { parameters -> (Parameters?) in
                return parameters
            }
            urlRequest = try request.urlRequest(with: paramInterceptor)
        } catch let error as HTTPError {
            completionHandler(.failure(error))
            return nil
        } catch let error {
            let err = HTTPError.request(service: request.service.baseUrl, path: request.path, error: error)
            completionHandler(.failure(err))
            return nil
        }
        
        var initalRequest: Request?
        switch requestType {
        case .data:
            initalRequest = manager.request(urlRequest)
            break
        case .download(let destination):
            initalRequest = manager.download(urlRequest, to: destination)
            break
        case .uploadFile(let fileURL):
            initalRequest = manager.upload(fileURL, with: urlRequest)
            break
        case .uploadFormData(let mutipartFormData):
            let multipartFormData: (AFMultipartFormData) -> Void = { formData in
                formData.applyMoyaMultipartFormData(mutipartFormData)
            }
            manager.upload(multipartFormData: multipartFormData, with: urlRequest, queue: queue) { result in
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
    
    
    /// 发起网络请求
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - alamofireRequest: Alamofire.Request
    ///   - callbackQueue: 回调线程
    ///   - completionHandler: 完成回调
    /// - Returns: 请求任务
    func sendAlamofireRequest<AF>(_ alamofireRequest: AF,
                                  request: R,
                                  queue: DispatchQueue?,
                                  progressHandler: ProgressHandler?,
                                  completionHandler: @escaping CompletionHandler)
        -> Task where AF: RequestAlterative , AF: Request {
            
            let statusCodes = request.validationType.statusCodes
            var progressAlamofireRequest = statusCodes.isEmpty ? alamofireRequest : alamofireRequest.validate(statusCode: statusCodes)
            
            if progressHandler != nil {
                progressAlamofireRequest = alamofireRequest.progress(queue: queue, progressHandler: progressHandler!)
            }
            
            progressAlamofireRequest = progressAlamofireRequest.response(queue: queue, completionHandler: completionHandler)
            progressAlamofireRequest.resume()
            
            return HTTPTask(progressAlamofireRequest)
    }
    
}

