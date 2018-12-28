//
//  HTTPClient+Internal.swift
//  HTTPClient
//
//  Created by zevwings on 2018/12/27.
//  Copyright © 2018 zevwings. All rights reserved.
//

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
    
    /// 发起网络请求
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - alamofireRequest: Alamofire.Request
    ///   - callbackQueue: 回调线程
    ///   - completionHandler: 完成回调
    /// - Returns: 请求任务
    internal func sendAlamofireRequest(_ alamofireRequest: AlamofireRequest,
                                       request: R,
                                       queue: DispatchQueue?,
                                       progressHandler: ProgressHandler?,
                                       completionHandler: @escaping CompletionHandler)
        -> Task? {
            var statusCodes: [Int] = []
            if let validator = request as? RequestableValidator {
                statusCodes = validator.validationType.statusCodes
            }
            
            var validationRequest = statusCodes.isEmpty ?
                alamofireRequest :
                alamofireRequest.validate(statusCode: statusCodes)
            
            if progressHandler != nil {
                validationRequest = validationRequest.progress(queue: queue, progressHandler: progressHandler!)
            }
            validationRequest = validationRequest.response(queue: queue, completionHandler: completionHandler)
            validationRequest.resume()
            return HTTPTask(validationRequest)
    }
    
    /// 构建URLRequest，从一个Requestable转换为URLRequest
    ///
    /// - Parameter request: Requestable
    /// - Returns: URLRequest
    /// - Throws: HTTPError
    internal func buildURLRequest(_ request: R) throws -> URLRequest {
        guard let url = URL(string: request.path, relativeTo: request.service.url) else {
            throw HTTPError.invalidUrl(service: request.service.baseUrl,
                                       path: request.path)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        request.headerFields?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        var encoding: AFParameterEncoding
        switch request.formatter {
        case .json:
            encoding = AFJSONEncoding.default
        case .url:
            encoding = AFURLEncoding.default
        }
        
        var parameters = request.parameters
        if let interceptor = request as? RequestableInterceptor {
            parameters = try interceptor.intercept(paramters: parameters)
        }
        
        if let validator = request as? RequestableValidator {
            try validator.validate(paramters: parameters)
        }
        
        urlRequest = try encoding.encode(urlRequest, with: parameters)
        
        if let interceptor = request as? RequestableInterceptor {
            return try interceptor.intercept(request: urlRequest)
        } else {
            return urlRequest
        }
    }
    
    /// 构建一个`Alamofire.Request`，从`Requestable`转换为`Alamofire.Request`
    ///
    /// - Parameters:
    ///   - request: Requestable
    ///   - requestType: RequestType
    ///   - queue: 回调线程
    /// - Returns: Alamofire.Request
    /// - Throws: HTTPError
    internal func buildAlamofireRequest(_ request: R,
                                        requestType: RequestType,
                                        queue: DispatchQueue?) throws
        -> AlamofireRequest {
            let urlRequest = try buildURLRequest(request)
            switch requestType {
            case .data:
                return manager.request(urlRequest)
            case .download(let destination):
                return manager.download(urlRequest, to: destination)
            case .uploadFile(let fileURL):
                return manager.upload(fileURL, with: urlRequest)
            case .uploadFormData(let mutipartFormData):
                let multipartFormData: (AFMultipartFormData) -> Void = { formData in
                    formData.applyMoyaMultipartFormData(mutipartFormData)
                }
                var initalRequest: AFUploadRequest?
                var error: Error?
                manager.upload(multipartFormData: multipartFormData, with: urlRequest, queue: queue) { result in
                    switch result {
                    case .success(let uploadRequest, _, _):
                        initalRequest = uploadRequest
                    case .failure(let err):
                        error = err
                    }
                }
                guard let alamofireRequest = initalRequest else {
                    throw HTTPError.upload(service: request.service.baseUrl, path: request.path, error: error)
                }
                return alamofireRequest
            }
    }
}
