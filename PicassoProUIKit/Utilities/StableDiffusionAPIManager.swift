//
//  StableDiffusionAPIManager.swift
//  PicassoPro
//
//  Created by mac 2019 on 9/21/23.
//

import Foundation

final class StableDiffusionAPIManager{
    private static let urlString = "https://stablediffusionapi.com/api/v3/text2img"
//    private static let apiKey = "zAXjIPV7I9Sdl1YJ5e6Z4Zl5ucgjd62UbKJ4xrYHFeF47TWzmxFtNe95M4Dj" //bad
    private static let apiKey = "5MqpLpSJY3vBIPyWYQKZTzSlG9TF7JeZZeclqQT8jKYt7lHjkKQLr7HwCvox"
    
    private var parameters: [String: Any] = [
        "key": apiKey,
        "prompt": "",
        "negative_prompt": "",
        "width": "512",
        "height": "512",
        "samples": "1",
        "num_inference_steps": "20",
        "seed": "",
        "guidance_scale": 7.5,
        "safety_checker": "yes",
        "multi_lingual": "no",
        "panorama": "no",
        "self_attention": "no",
        "upscale": "no",
        "embeddings_model": "",
        "webhook": "",
        "track_id": ""
    ]
    
    static let shared = StableDiffusionAPIManager()
    
    private init(){}
    
    private func updateParameters(from prompt: PromptInput) {
        parameters.updateValue(prompt.expression, forKey: "prompt")
        parameters.updateValue(prompt.excludedWords, forKey: "negative_prompt")
        parameters.updateValue(prompt.outputImageWidth, forKey: "width")
        parameters.updateValue(prompt.outputImageHeight, forKey: "height")
    }
    
    func getImageUrls(prompt: PromptInput, completed: @escaping (Result<ApiResponseData, StableDiffusionError>) -> Void) async {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2){
            completed(.success(ApiResponseData(status: "", generationTime: 0.0, id: 0, output: ["https://i.natgeofe.com/n/49f1c59b-095d-47a6-b72c-92bc6740a37c/tpc18-outdoor-gallery-1693450-12040196_03_square.jpg"], meta: ApiResponseMeta(H: 1, W: 1, enable_attention_slicing: "", file_prefix: "", guidance_scale: 0.0, model: "", n_samples: 0, negative_prompt: "", outdir: "", prompt: "", revision: "", safetychecker: "", seed: 0, steps: 0, vae: ""))))
            
        }
        
        /*
        guard let url = URL(string: StableDiffusionAPIManager.urlString) else {
            completed(.failure(StableDiffusionError.networkError("Invalid URL")))
            return
        }
        
        updateParameters(from: prompt)
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else{
            completed(.failure(StableDiffusionError.networkError("Invalid HTTP Body")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        if let (data, _) = try? await URLSession.shared.data(for: request) {
            
            if let apiResponseData = try? JSONDecoder().decode(ApiResponseData.self, from: data){
                completed(.success(apiResponseData))
            }
            else if let rateLimitResponseResult = try? JSONDecoder().decode(RateLimitExceededResponse.self, from: data){
                completed(.failure(StableDiffusionError.apiError(rateLimitResponseResult.message)))
            }
            else if let invalidKeyResponse = try? JSONDecoder().decode(InvalidKeyResponse.self, from: data){
                completed(.failure(StableDiffusionError.apiError(invalidKeyResponse.message)))
            }
            else if let failedResponse = try? JSONDecoder().decode(FailedResponse.self, from: data){
                completed(.failure(StableDiffusionError.apiError(failedResponse.message)))
            }
            else if let validationErrorsResponse = try? JSONDecoder().decode(ValidationErrorsResponse.self, from: data){
                completed(.failure(StableDiffusionError.apiError(validationErrorsResponse.message.prompt.first ?? "")))
            }
            else if let emptyModalIdErrorResponse = try? JSONDecoder().decode(EmptyModalIdErrorResponse.self, from: data){
                completed(.failure(StableDiffusionError.apiError(emptyModalIdErrorResponse.message)))
            }
            else{
                completed(.failure(StableDiffusionError.unknownError()))
            }
        }
        else{
            completed(.failure(StableDiffusionError.networkError("Unknown Network Error")))
        }*/
    }
}
