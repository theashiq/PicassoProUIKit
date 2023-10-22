//
//  ImageGenerator.swift
//  PicassoProUIKit
//
//  Created by mac 2019 on 10/23/23.
//

import Foundation

protocol ImageGenerator {
    func getImageUrls(prompt: PromptInput, completed: @escaping (Result<[URL], ImageGenerationError>) -> Void) async
}

enum ImageGenerationError: Error, LocalizedError, Equatable{
    case apiError(String)
    case networkError(String)
    case unknownError(String = "An  error occurred. Please retry after sometime")
    
    var errorDescription: String?{
        switch self{
        case .apiError(let message):
            return message
        case .networkError(let message):
            return message
        case .unknownError(let message):
            return message
        }
    }
}

extension ImageGenerationError: RawRepresentable {

    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        switch rawValue {
        case "API Error":  self = .apiError("API Error")
        case "Network Error":  self = .networkError("Network Error")
        case "Error":  self = .unknownError()
        default:
            return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .apiError: return "API Error"
        case .networkError: return "Network Error"
        case .unknownError: return "Unknown Error"
        }
    }
}


class DummyImageGenerator: ImageGenerator{
    
    private let dummyImageUrl1 = URL(string: "https://i.natgeofe.com/n/49f1c59b-095d-47a6-b72c-92bc6740a37c/tpc18-outdoor-gallery-1693450-12040196_03_square.jpg")!
    private let dummyImageUrl2 = URL(string: "https://upload.wikimedia.org/wikipedia/en/thumb/9/93/Burj_Khalifa.jpg/1200px-Burj_Khalifa.jpg")!
    
    func getImageUrls(prompt: PromptInput, completed: @escaping (Result<[URL], ImageGenerationError>) -> Void) async {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2){
            completed(.success([self.dummyImageUrl1, self.dummyImageUrl2].shuffled()))
        }
    }
}
