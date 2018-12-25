//
//  HTTPClient+Rx.swift
//  RxHTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

import RxSwift
#if !COCOAPODS
import HTTPClient
#endif
/*
extension HTTPClient: ReactiveCompatible {}

public extension Reactive where Base: Client {
    
    public func send(request: Base.R, queue: DispatchQueue? = .main) -> Single<Response> {
        
        return Single.create(subscribe: { [weak base] single -> Disposable in
            let task = base?.send(request: request, queue: queue, progressHandler: nil, completionHandler: {
                result in
                
                switch result {
                case .success(let value):
                    single(.success(value))
                    break
                case .failure(let error):
                    single(.error(error))
                    break
                }
            })
            
            return Disposables.create {
                task?.cancel()
            }
        })
    }
    
    // MARK: Download
    @discardableResult
    public func downlown(request: Base.R, destination: DownloadDestination? = nil, queue: DispatchQueue? = .main) -> Single<Response> {
        
        return Single.create(subscribe: { [weak base] single -> Disposable in
            let task = base?.downlown(request: request, destination: destination, queue: queue, progressHandler: nil, completionHandler: {
                result in
                
                switch result {
                case .success(let value):
                    single(.success(value))
                    break
                case .failure(let error):
                    single(.error(error))
                    break
                }
            })
            
            return Disposables.create {
                task?.cancel()
            }
        })
    }
    
    // MARK: Upload
    public func upload(request: Base.R, fileURL: URL, queue: DispatchQueue? = .main) -> Single<Response> {
        
        return Single.create(subscribe: { [weak base] single -> Disposable in
            
            let task = base?.upload(request: request, fileURL: fileURL, queue: queue, progressHandler: nil, completionHandler: {
                result in
                
                switch result {
                case .success(let value):
                    single(.success(value))
                    break
                case .failure(let error):
                    single(.error(error))
                    break
                }
            })
            
            return Disposables.create {
                task?.cancel()
            }
        })
    }
    
    @discardableResult
    public func upload(request: Base.R, mutipartFormData: [MultipartFormData], queue: DispatchQueue? = .main) -> Single<Response> {
        
        return Single.create(subscribe: { [weak base] single -> Disposable in
            
            let task = base?.upload(request: request, mutipartFormData: mutipartFormData, queue: queue, progressHandler: nil, completionHandler: {
                result in
                
                switch result {
                case .success(let value):
                    single(.success(value))
                    break
                case .failure(let error):
                    single(.error(error))
                    break
                }
            })
            
            return Disposables.create {
                task?.cancel()
            }
        })
    }
}

*/
