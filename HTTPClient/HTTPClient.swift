//
//  HTTPClient.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

import Result

public final class HTTPClient<R: Requestable>: Client {
    
    public let manager: SessionManager
    
    public init() {
        manager = HTTPClient.defaultAlamofireManager()
    }
    
    // MARK: Data
    @discardableResult
    public func send(request: R,
                     queue: DispatchQueue? = .main,
                     progressHandler: ProgressHandler? = nil,
                     completionHandler: @escaping (CompletionHandler))
        -> Task? {
            
            let errorHandler: (Error) -> Void = { error in
                self.buildErrorHander(request: request, error: error, completionHandler: completionHandler)
            }
            
            guard let urlRequest = Builder(request).build(errorHandler) else {
                return nil
            }
            
            let initalRequest = manager.request(urlRequest)
            let statusCodes = request.validationType.statusCodes
            let alamofireRequest = statusCodes.isEmpty ? initalRequest : initalRequest.validate(statusCode: statusCodes)
            let task = sendAlamofireRequest(alamofireRequest,
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
            
            let errorHandler: (Error) -> Void = { error in
                self.buildErrorHander(request: request, error: error, completionHandler: completionHandler)
            }
            
            guard let urlRequest = Builder(request).build(errorHandler) else {
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
            let statusCodes = request.validationType.statusCodes
            let alamofireRequest = statusCodes.isEmpty ? initalRequest : initalRequest.validate(statusCode: statusCodes)
            
            let task = sendAlamofireRequest(alamofireRequest,
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
            
            let errorHandler: (Error) -> Void = { error in
                self.buildErrorHander(request: request, error: error, completionHandler: completionHandler)
            }
            
            guard let urlRequest = Builder(request).build(errorHandler) else {
                return nil
            }
            
            let initalRequest = manager.upload(fileURL, with: urlRequest)
            let statusCodes = request.validationType.statusCodes
            let alamofireRequest = statusCodes.isEmpty ? initalRequest : initalRequest.validate(statusCode: statusCodes)
            
            let task = sendAlamofireRequest(alamofireRequest,
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
            
            let errorHandler: (Error) -> Void = { error in
                self.buildErrorHander(request: request, error: error, completionHandler: completionHandler)
            }
            
            guard let urlRequest = Builder(request).build(errorHandler) else {
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
    }
}

