//
//  UIImageView+Ext.swift
//  PicassoProUIKit
//
//  Created by mac 2019 on 10/16/23.
//

import UIKit

extension UIImageView {
    func load(url: URL, completion: @escaping (Bool)->Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion(true)
                    }
                }
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    completion(false)
                }
            }
        }
    }
}
