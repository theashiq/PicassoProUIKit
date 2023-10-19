//
//  AlertStatus.swift
//  PicassoProUIKit
//
//  Created by mac 2019 on 10/16/23.
//

import Foundation

enum AlertStatus: Equatable{
    case none
    case success(String, String)
    case fail(String, String)
    
    var message: String{
        switch self{
        case .none:
            return ""
        case .success( _, let message):
            return message
        case .fail(_, let message):
            return message
        }
    }
    
    var title: String{
        switch self{
        case .none:
            return ""
        case .success(let title, _):
            return title
        case .fail(let title, _):
            return title
        }
    }
}

extension AlertStatus{
    init(from sdError: StableDiffusionError) {
        switch sdError{
        case .apiError(let message):
            self = .success(sdError.rawValue, message)
        case .networkError(let message):
            self = .success(sdError.rawValue, message)
        case .unknownError(let message):
            self = .success(sdError.rawValue, message)
        }
    }
}
