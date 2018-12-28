//
//  ModelResponseSerializerProtocol.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/28.
//  Copyright © 2018 zevwings. All rights reserved.
//

// TODO: - 升级到alamofire 5.0 后，可将两个ResponseSerializer合并

/// 用于DataRequest和UploadRequest返回数据
struct DataResponseSerializer<Value: Model>: AFDataResponseSerializerProtocol {
    
    typealias SerializedObject = Value
    
    var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> AFResult<Value>
    
    init (serializeResponse: @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?) -> AFResult<Value>) {
        self.serializeResponse = serializeResponse
    }
    
    static func serialize(with reusltElemtnKey: String) -> DataResponseSerializer<Value> {
        
        return DataResponseSerializer { (request, response, data, error) -> AFResult<Value> in
            
            if let err = error {
                switch err._code {
                case NSURLErrorTimedOut:
                    return .failure(HTTPError.timeout(request: request, response: response))
                case NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost:
                    return .failure(HTTPError.connectionLost(request: request, response: response))
                default:
                    return .failure(err)
                }
            }

            guard let jsonData = data, !jsonData.isEmpty else {
                return .failure(HTTPError.emptyResponse(request: request, response: response))
            }
            
            do {
                let options: JSONSerialization.ReadingOptions = [.allowFragments, .mutableLeaves, .mutableContainers]
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: options)
                let result = try Value.transform(jsonObject, atKeyPath: "")
                return .success(result)
            } catch {
                return .failure(error)
            }
        }
    }
}

/// 用于Download返回数据
struct DownloadResponseSerializer<Value: Model>: AFDownloadResponseSerializerProtocol {
    
    typealias SerializedObject = Value
    
    var serializeResponse: (URLRequest?, HTTPURLResponse?, URL?, Error?) -> AFResult<Value>

    init (serializeResponse: @escaping (URLRequest?, HTTPURLResponse?, URL?, Error?) -> AFResult<Value>) {
        self.serializeResponse = serializeResponse
    }
    
    static func serialize(with reusltElemtnKey: String) -> DownloadResponseSerializer {
        
        return DownloadResponseSerializer { (request, response, fileURL, error) -> AFResult<Value> in
            if let err = error {
                switch err._code {
                case NSURLErrorTimedOut:
                    return .failure(HTTPError.timeout(request: request, response: response))
                case NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost:
                    return .failure(HTTPError.connectionLost(request: request, response: response))
                default:
                    return .failure(err)
                }
            }
            
            guard let fileURL = fileURL else {
                return .failure(HTTPError.emptyResponse(request: request, response: response))
            }
            
            do {
                let data = try Data(contentsOf: fileURL)
                let result = try Value.transform(data, atKeyPath: "")
                return .success(result)
            } catch {
                return .failure(error)
            }
        }
    }
}
