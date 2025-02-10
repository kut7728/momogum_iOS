//
//  Const.swift
//  momogum
//
//  Created by nelime on 2/10/25.
//

import Foundation

let BaseURL = Bundle.main.infoDictionary?["BASE_API"] ?? "error"

let BaseAPI = "http://\(BaseURL)"
