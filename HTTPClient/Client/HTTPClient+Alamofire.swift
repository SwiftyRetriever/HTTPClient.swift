//
//  HTTPClient+Alamofire.swift
//  HTTPClient
//
//  Created by zevwings on 2018/12/28.
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

protocol AlamofireRequest {
    
    /// 请求任务
    var task: URLSessionTask? { get }
    
    /// 发送到服务器的请求
    var request: URLRequest? { get }
    
    /// 从服务器接收到的返回数据
    var response: HTTPURLResponse? { get }
    
    /// 开始请求
    func resume()
    
    /// 暂停请求
    func suspend()
    
    /// 取消请求
    func cancel()
    
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

extension AlamofireRequest where Self: DataRequest {
    
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
            
            //            let result = self.transformResponseToResult(handler.response,
            //                                                        request: handler.request,
            //                                                        data: handler.data,
            //                                                        error: handler.error,
            //                                                        timeline: handler.timeline)
            //            completionHandler(result)
        })
    }
}

extension AlamofireRequest where Self: UploadRequest {
    
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

extension AlamofireRequest where Self: DownloadRequest {

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
//            let result = self.transformResponseToResult(handler.response,
//                                                        request: handler.request,
//                                                        data: handler.resumeData,
//                                                        error: handler.error,
//                                                        timeline: handler.timeline)
//            completionHandler(result)
        })
    }
}

extension DataRequest: AlamofireRequest {}
extension DownloadRequest: AlamofireRequest {}
