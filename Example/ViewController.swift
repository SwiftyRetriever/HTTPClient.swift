//
//  ViewController.swift
//  Example
//
//  Created by zevwings on 2018/12/25.
//  Copyright © 2018 zevwings. All rights reserved.
//

import UIKit
import HTTPClient

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

enum DanluService: Serviceable {
    var baseUrl: String {
        return ""
    }
    case `default`
}

struct LoginRequest: Requestable {
    var service: DanluService { return .default }
    
    var path: String { return "" }
    
    var method: HTTPMethod { return .get }
    
    var parameters: Parameters? { return [:] }
    
    var formatter: ParameterFormatter { return .json }
    
    typealias Service = DanluService
    
    var get: String { return "" }

}
