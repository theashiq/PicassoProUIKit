//
//  PicassoProViewController.swift
//  PicassoProUIKit
//
//  Created by mac 2019 on 10/16/23.
//

import UIKit

class PicassoProViewController: UIViewController {
    
    @IBOutlet weak var viewEmptyPrompt: UIStackView!
    @IBOutlet weak var labelExpression: UILabel!
    
    @IBOutlet weak var viewOutput: UIStackView!
    @IBOutlet weak var imageOutput: UIImageView!
    
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    
    @IBOutlet weak var buttonPromptInput: UIButton!
    @IBOutlet weak var viewInputButtonIndicator: UIView!
    
    @IBOutlet weak var viewProgressContainer: UIStackView!
    @IBOutlet weak var viewProgress: UIActivityIndicatorView!
    @IBOutlet weak var labelProgress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewEmptyPrompt.isHidden = true
        
        labelProgress.text = "Loading"
        viewProgress.startAnimating()
    }


}

