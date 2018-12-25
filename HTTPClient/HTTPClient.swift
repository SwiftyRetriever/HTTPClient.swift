//
//  HTTPClient.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Result
/*
public final class HTTPClient<R: Requestable>: Client {
    
    public typealias URLRequestConstractor = (Requestable) -> URLRequest?
    
    public let manager: SessionManager
    
    public init(manager: SessionManager = HTTPClient.defaultAlamofireManager()) {
        self.manager = manager
    }
    
    /*
    
//    func buildURLRequest(_ request: R) -> Result<URLRequest, HTTPError> {
//
//        do {
//            let parameters = try request.intercept(paramters: request.parameters)
//            let constructor = Constructor(service: request.service,
//                                          path: request.path,
//                                          method: request.method,
//                                          headerFields: request.headers,
//                                          parameters: parameters,
//                                          formatter: request.formatter)
//            var urlRequest = try constructor.urlRequest()
//            urlRequest = try request.intercept(request: urlRequest)
//            return .success(urlRequest)
//        } catch let error as HTTPError {
//            return .failure(error)
//        } catch let error {
//            let err = HTTPError.request(service: request.service.baseUrl, path: request.path, error: error)
//            return .failure(err)
//        }
//    }
    
    // MARK: Data
    @discardableResult
    public func send(request: R,
                     queue: DispatchQueue? = .main,
                     progressHandler: ProgressHandler? = nil,
                     completionHandler: @escaping (CompletionHandler))
        -> Task? {
            
            let urlRequest: URLRequest
            switch buildURLRequest(request) {
            case .success(let value):
                urlRequest = value
                break
            case .failure(let error):
                completionHandler(.failure(error))
                return nil
            }
            
            let initalRequest = manager.request(urlRequest)
            let task = sendAlamofireRequest(initalRequest,
                                            request: request,
                                            queue: queue,
                                            progressHandler: progressHandler,
                                            completionHandler: completionHandler)
            return task
    }
    
    // MARK: Download
    @discardableResult
    public func downlown(request: R,
                         destination: DownloadDestination? = nil,
                         queue: DispatchQueue? = .main,
                         progressHandler: ProgressHandler?,
                         completionHandler: @escaping (CompletionHandler))
        -> Task? {
            
            let urlRequest: URLRequest
            switch buildURLRequest(request) {
            case .success(let value):
                urlRequest = value
                break
            case .failure(let error):
                completionHandler(.failure(error))
                return nil
            }
            
            var destination = destination
            if destination == nil {
                destination = DownloadRequest.suggestedDownloadDestination(
                    for: .cachesDirectory,
                    in: .userDomainMask
                )
            }
            
            let initalRequest = manager.download(urlRequest, to: destination)
            let task = sendAlamofireRequest(initalRequest,
                                            request: request,
                                            queue: queue,
                                            progressHandler: progressHandler,
                                            completionHandler: completionHandler)
            return task
    }
    
    // MARK: Upload
    @discardableResult
    public func upload(request: R,
                       fileURL: URL,
                       queue: DispatchQueue? = .main,
                       progressHandler: ProgressHandler? = nil,
                       completionHandler: @escaping (CompletionHandler))
        -> Task? {
            
            let urlRequest: URLRequest
            switch buildURLRequest(request) {
            case .success(let value):
                urlRequest = value
                break
            case .failure(let error):
                completionHandler(.failure(error))
                return nil
            }
            
            let initalRequest = manager.upload(fileURL, with: urlRequest)
            let task = sendAlamofireRequest(initalRequest,
                                            request: request,
                                            queue: queue,
                                            progressHandler: progressHandler,
                                            completionHandler: completionHandler)
            return task
    }
    
    @discardableResult
    public func upload(request: R,
                       mutipartFormData: [MultipartFormData],
                       queue: DispatchQueue? = .main,
                       progressHandler: ProgressHandler? = nil,
                       completionHandler: @escaping (CompletionHandler))
        -> Task? {
            
            let urlRequest: URLRequest
            switch buildURLRequest(request) {
            case .success(let value):
                urlRequest = value
                break
            case .failure(let error):
                completionHandler(.failure(error))
                return nil
            }
            
            let multipartFormData: (AFMultipartFormData) -> Void = { formData in
                formData.applyMoyaMultipartFormData(mutipartFormData)
            }
            
            var task: Task?
            manager.upload(multipartFormData: multipartFormData, with: urlRequest, queue: queue) { result in
                switch result {
                case .success(let uploadRequest, _, _):
                    task = self.sendAlamofireRequest(uploadRequest,
                                                     request: request,
                                                     queue: queue,
                                                     progressHandler: progressHandler,
                                                     completionHandler: completionHandler)
                    break
                case .failure(let error):
                    let error = HTTPError.upload(service: request.service.baseUrl, path: request.path, error: error)
                    completionHandler(.failure(error))
                    break
                }
            }
            
            return task
    }*/
}

*/
