//
//  HTTPTask.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

public final class HTTPTask: Task {
    
    public typealias CancelAction = () -> ()
    
    public private(set) var isCancelled: Bool = false
    
    public let request: Request
    
    private let cancelAction: CancelAction
    
    private var lock: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    public convenience init(_ request: Request) {
        self.init(request) {
            request.cancel()
        }
    }
    
    public init(_ request: Request, action: @escaping CancelAction) {
        self.request = request
        self.cancelAction = action
    }
    
    public func resume() {
        request.resume()
    }
    
    public func suspend() {
        request.suspend()
    }
    
    public func cancel() {
        _ = lock.wait(timeout: DispatchTime.distantFuture)
        defer { lock.signal() }
        guard !isCancelled else { return }
        isCancelled = true
        cancelAction()
    }
}

extension HTTPTask: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return request.description
    }
    
    public var debugDescription: String {
        return request.debugDescription
    }
}

