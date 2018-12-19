//
//  AFRequestAlterative.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Result

public typealias ProgressHandler = (Progress) -> Void
public typealias CompletionHandler = (Result<Response, HTTPError>) -> Void

/// 格式化Alamofire网络请求，添加网络请求统一返回格式
protocol AFRequestAlterative {
    
    /// 格式化网络请求进度回调
    ///
    /// - Parameters:
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    /// - Returns: Request
    func progress(queue: DispatchQueue?, progressHandler: @escaping ProgressHandler) -> Self
    
    /// 格式化网络请求回调内容
    ///
    /// - Parameters:
    ///   - queue: 回调线程
    ///   - completionHandler: 结果回调
    /// - Returns: Request
    func response(queue: DispatchQueue?, completionHandler: @escaping CompletionHandler) -> Self
    
    /// 格式化网络请求返回Code验证
    ///
    /// - Parameter acceptableStatusCodes: 验证序列
    /// - Returns: Request
    func validate<S>(statusCode acceptableStatusCodes: S) -> Self where S : Sequence, S.Element == Int

}

extension AFRequestAlterative {
    
    private func transformResponseToResult(_ response: HTTPURLResponse?, request: URLRequest?, data: Data?, error: Error?, timeline: Timeline? ) -> Result<Response, HTTPError> {
        switch (response, error) {
        case let (.some(response), .none):
            let result = Response(statusCode: response.statusCode, data: data, request: request, response: response, timeline: timeline)
            return .success(result)
        case let ( _, .some(error)):
            switch error._code {
            case NSURLErrorTimedOut:
                return .failure(HTTPError.timeout(request: request, response: response))
            case NSURLErrorNetworkConnectionLost:
                return .failure(HTTPError.connectionLost(request: request, response: response))
            default:
                let error = HTTPError.underlying(error, request: request, response: response)
                return .failure(error)
            }
        default:
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
            let err = HTTPError.underlying(error, request: request, response: response)
            return .failure(err)
        }
    }
}

extension AFRequestAlterative where Self: DataRequest {
    
    /// 格式化网络请求进度回调
    ///
    /// - Parameters:
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    /// - Returns: Request
    func progress(queue: DispatchQueue?, progressHandler: @escaping ProgressHandler) -> Self  {
        return downloadProgress(queue: queue ?? .main, closure: { progress in
            progressHandler(progress)
        })
    }
    
    /// 格式化网络请求回调内容
    ///
    /// - Parameters:
    ///   - queue: 回调线程
    ///   - completionHandler: 结果回调
    /// - Returns: Request
    func response(queue: DispatchQueue?, completionHandler: @escaping CompletionHandler) -> Self  {
        
        return response(queue: queue, completionHandler: { handler in
            
            let result = self.transformResponseToResult(handler.response,
                                                        request: handler.request,
                                                        data: handler.data,
                                                        error: handler.error,
                                                        timeline: handler.timeline)
            completionHandler(result)
        })
    }
}

extension AFRequestAlterative where Self: UploadRequest {
    
    /// 格式化网络请求进度回调
    ///
    /// - Parameters:
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    /// - Returns: Request
    @discardableResult
    func progress(queue: DispatchQueue?, progressHandler: @escaping ProgressHandler) -> Self {
        return uploadProgress(queue: queue ?? .main, closure: { progress in
            progressHandler(progress)
        })
    }
}

extension AFRequestAlterative where Self: DownloadRequest {
    
    /// 格式化网络请求进度回调
    ///
    /// - Parameters:
    ///   - queue: 回调线程
    ///   - progressHandler: 进度回调
    /// - Returns: Request
    func progress(queue: DispatchQueue?, progressHandler: @escaping ProgressHandler) -> Self {
        return downloadProgress(queue: queue ?? .main, closure: { progress in
            progressHandler(progress)
        })
    }
    
    /// 格式化网络请求回调内容
    ///
    /// - Parameters:
    ///   - queue: 回调线程
    ///   - completionHandler: 结果回调
    /// - Returns: Request
    func response(queue: DispatchQueue?, completionHandler: @escaping CompletionHandler) -> Self {
        
        return response(queue: queue, completionHandler: { handler in
            let result = self.transformResponseToResult(handler.response,
                                                        request: handler.request,
                                                        data: handler.resumeData,
                                                        error: handler.error,
                                                        timeline: handler.timeline)
            completionHandler(result)
        })
    }
}

extension DataRequest: AFRequestAlterative {}
extension DownloadRequest: AFRequestAlterative {}

