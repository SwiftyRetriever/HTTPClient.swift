//
//  MultipartFormData.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

public struct MultipartFormData {
    
    public enum FormDataType {
        case data(Foundation.Data)
        case file(URL)
        case stream(InputStream, UInt64)
    }
    
    public init(_ formDataType: FormDataType, name: String, fileName: String? = nil, mimeType: String? = nil) {
        self.formDataType = formDataType
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
    public let formDataType: FormDataType
    
    public let name: String
    
    public let fileName: String?
    
    public let mimeType: String?
    
}

// MARK: Alamofire MultipartFormData
internal extension AFMultipartFormData {
    
    func append(data: Data, bodyPart: MultipartFormData) {
        if let mimeType = bodyPart.mimeType {
            if let fileName = bodyPart.fileName {
                append(data, withName: bodyPart.name, fileName: fileName, mimeType: mimeType)
            } else {
                append(data, withName: bodyPart.name, mimeType: mimeType)
            }
        } else {
            append(data, withName: bodyPart.name)
        }
    }
    
    func append(fileURL url: URL, bodyPart: MultipartFormData) {
        if let fileName = bodyPart.fileName, let mimeType = bodyPart.mimeType {
            append(url, withName: bodyPart.name, fileName: fileName, mimeType: mimeType)
        } else {
            append(url, withName: bodyPart.name)
        }
    }
    
    func append(stream: InputStream, length: UInt64, bodyPart: MultipartFormData) {
        append(stream, withLength: length, name: bodyPart.name, fileName: bodyPart.fileName ?? "", mimeType: bodyPart.mimeType ?? "")
    }
    
    func applyMoyaMultipartFormData(_ multipartBody: [MultipartFormData]) {
        
        multipartBody.forEach { bodyPart in
            switch bodyPart.formDataType {
            case .data(let data):
                append(data: data, bodyPart: bodyPart)
            case .file(let url):
                append(fileURL: url, bodyPart: bodyPart)
            case .stream(let stream, let length):
                append(stream: stream, length: length, bodyPart: bodyPart)
            }
        }
    }
}

