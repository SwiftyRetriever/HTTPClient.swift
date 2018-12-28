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
internal typealias AFRequest = Alamofire.Request
internal typealias AFDataRequest = Alamofire.DataRequest
internal typealias AFUploadRequest = Alamofire.UploadRequest
internal typealias AFDownloadRequest = Alamofire.DownloadRequest
internal typealias AFMultipartFormData = Alamofire.MultipartFormData

// Result
internal typealias AFResult = Alamofire.Result
//internal typealias AFResponseSerializer = Alamofire.ResponseSerializer
internal typealias AFDataResponseSerializerProtocol = Alamofire.DataResponseSerializerProtocol
internal typealias AFDownloadResponseSerializerProtocol = Alamofire.DownloadResponseSerializerProtocol

// ParameterEncoding
internal typealias AFParameterEncoding = Alamofire.ParameterEncoding
internal typealias AFJSONEncoding = Alamofire.JSONEncoding
internal typealias AFURLEncoding = Alamofire.URLEncoding

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
    func progress(queue: DispatchQueue?, progressHandler: @escaping ProgressHandler) -> Self
    
    /// 格式化网络请求回调内容
    func response(queue: DispatchQueue?, completionHandler: @escaping CompletionHandler) -> Self
    
    /// 格式化网络请求返回Code验证
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
        let serilizer = DataResponseSerializer<None>.serialize(with: "")
        return response(queue: queue, responseSerializer: serilizer, completionHandler: { response in
            switch response.result {
            case .success(let value):
                break
            case .failure(let error):
                break
            }
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
        
        let serilizer = DownloadResponseSerializer<None>.serialize(with: "")
        return response(queue: queue, responseSerializer: serilizer, completionHandler: { response in
            switch response.result {
            case .success(let value):
                break
            case .failure(let error):
                break
            }
        })
    }
}

extension DataRequest: AlamofireRequest {}
extension DownloadRequest: AlamofireRequest {}
