//
//  HTTPClient+Internal.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//
/*
extension HTTPClient {
    
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
    
    public final class func defaultRequestConstructor<R>(_ request: R) -> URLRequest? where R: Requestable {
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
        -> Task where AF: AFRequestAlterative , AF: Request {
            
            let statusCodes = request.validationType.statusCodes
            var progressAlamofireRequest = statusCodes.isEmpty ? alamofireRequest : alamofireRequest.validate(statusCode: statusCodes)
            
            if progressHandler != nil {
                progressAlamofireRequest = alamofireRequest.progress(queue: queue, progressHandler: progressHandler!)
            }
            
            progressAlamofireRequest = progressAlamofireRequest.response(queue: queue, completionHandler: completionHandler)
            progressAlamofireRequest.resume()
            
            return HTTPTask(progressAlamofireRequest)
    }
    
    /// 处理构建Request时的错误信息
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - error: HTTPError
    ///   - completionHandler: 完成回掉
    func buildErrorHander(request: R, error: Error, completionHandler: @escaping CompletionHandler) {
        
        if let err = error as? HTTPError {
            completionHandler(.failure(err))
        } else {
            let err = HTTPError.request(service: request.service.baseUrl, path: request.path, error: error)
            completionHandler(.failure(err))
        }
    }

}

*/
