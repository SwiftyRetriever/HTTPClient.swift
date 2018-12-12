//
//  Task.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

public protocol Task {
    
    /// 任务是否取消
    var isCancelled: Bool { get }
    
    /// 启动/恢复任务
    func resume()
    
    /// 暂停任务
    func suspend()
    
    /// 取消任务
    func cancel()
}

