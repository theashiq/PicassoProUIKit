//
//  PicassoProViewController.swift
//  PicassoProUIKit
//
//  Created by mac 2019 on 10/16/23.
//

import UIKit

class PicassoProViewController: UIViewController {
    
    //MARK: - IBOutlets
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
    
    //MARK: - Constructors
    
    init(imageGenerator: ImageGenerator) {
        self.imageGenerator = imageGenerator
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.imageGenerator = DummyImageGenerator()
        super.init(coder: coder)
    }
    
    //MARK: - Properties
    private let imageGenerator: ImageGenerator
    
    private var prompt: PromptInput =  .empty {
        didSet {
            if !isGeneratingImage {
                alertStatus = .none
                generateImage()
            }
            else{
                alertStatus = .fail("Multiple Requests", "Please wait. A prompt is being processed at this moment")
            }
            
            labelExpression.text = prompt.expression
            viewEmptyPrompt.isHidden = hideIndicators
            viewInputButtonIndicator.isHidden = hideIndicators
        }
    }
    
    private var imageSaveState: TaskState = .toBeDone{
        didSet{
            switch imageSaveState {
            case .invalid:
                buttonSave.titleLabel?.text = "Save"
                buttonSave.isEnabled = false
            case .toBeDone:
                buttonSave.titleLabel?.text = "Save"
                buttonSave.isEnabled = true
            case .doing:
                buttonSave.titleLabel?.text = "Saving"
                buttonSave.isEnabled = false
            case .done:
                buttonSave.titleLabel?.text = "Saved"
                buttonSave.isEnabled = false
            case .failed:
                buttonSave.titleLabel?.text = "Try Again"
                buttonSave.isEnabled = true
            }
        }
    }
    private var canShareImage = false{
        didSet{
            buttonShare.isEnabled = canShareImage
        }
    }
    
    private var alertStatus: AlertStatus = .none
    private var isGeneratingImage: Bool = false{
        didSet{
            updateProgressLabel(isGeneratingImage ? "Processing" : nil)
        }
    }
    private var imageUrl: URL? = nil{
        didSet{
            fetchImage()
        }
    }
    
    var hideIndicators: Bool{
        !(prompt.isEmpty && !isGeneratingImage && imageUrl == nil)
    }
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buttonPromptInput.addTarget(self, action: #selector(self.buttonInputTapped), for: .touchUpInside)
        buttonSave.addTarget(self, action: #selector(self.buttonSaveTapped), for: .touchUpInside)
        buttonShare.addTarget(self, action: #selector(self.buttonShareTapped), for: .touchUpInside)
        
        labelExpression.text = ""
        viewOutput.isHidden = true
        updateProgressLabel(nil)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.viewInputButtonIndicator.center = CGPointMake(self.viewInputButtonIndicator.center.x, self.viewInputButtonIndicator.center.y + 40); // set center
        }, completion: nil)
    }
    
    private func generateImage(){
        
        guard !prompt.isEmpty else { return }
        
        isGeneratingImage = true
        buttonPromptInput.isEnabled = false
        
        Task{
            await imageGenerator.getImageUrls(prompt: prompt){ [weak self] result in
                DispatchQueue.main.async{
                    self?.isGeneratingImage = false
                    self?.buttonPromptInput.isEnabled = true
                    switch result{
                    case .success(let urls):
                        self?.imageUrl = urls.first
                    case .failure(let error):
                        self?.imageUrl = nil
                        self?.alertStatus = .init(from: error)
                    }
                }
            }
        }
    }
    
    private func fetchImage(){
        updateProgressLabel("Loading")
        
        if let imageUrl {
            imageOutput.load(url: imageUrl){ [weak self] result in
                DispatchQueue.main.async{
                    self?.canShareImage = result
                    self?.imageSaveState = result ? .toBeDone : .invalid
                    self?.updateProgressLabel(nil)
                    
                    if result{
                        self?.viewOutput.isHidden = false
                    }
                }
            }
        }
    }
    
    private func updateProgressLabel(_ text: String?){
        viewProgressContainer.isHidden = text == nil
        labelProgress.text = text
        
        if text == nil{
            viewProgress.stopAnimating()
            imageOutput.layer.opacity = 1
        }
        else{
            viewProgress.startAnimating()
            imageOutput.layer.opacity = 0.3
        }
    }
    
    //MARK: - User Intents
    
    @objc func buttonInputTapped(sender : UIButton){
        prompt = PromptInput(expression: "Rainy day sky and green trees soaked in rain", excludedWords: "", outputImageWidth: 512, outputImageHeight: 512)
    }
    
    @objc func buttonShareTapped(sender : UIButton){
        
        guard let uiImage = imageOutput.image else{
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems:  [uiImage, prompt.expression], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func buttonSaveTapped(sender : UIButton){
        
        guard let uiImage = imageOutput.image else{
            return
        }
        
        let imageSaver = ImageSaver()
        imageSaver.errorHandler = { error in
            self.alertStatus = .fail("Saving Failed", error.localizedDescription)
            self.imageSaveState = .failed
        }
        imageSaver.successHandler = { [self] in
            self.alertStatus = .success("Saved", "Image saved to gallery")
            self.imageSaveState = .done
        }
        imageSaver.writeToPhotoAlbum(image: uiImage)
    }
    
}

enum TaskState{
    case invalid
    case toBeDone
    case doing
    case done
    case failed
}
