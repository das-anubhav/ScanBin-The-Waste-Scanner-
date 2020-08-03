//
//  ViewController.swift
//  Spot the WASTE
//
//  Created by ANUBHAV DAS on 29/07/20.
//  Copyright © 2020 Captain Anubhav. All rights reserved.
//

import UIKit
import CoreML
import Vision
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var bgv: UIImageView!
    @IBOutlet weak var wastelabel: UILabel!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var gifImg: UIImageView!
    @IBOutlet var addItemView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    var effect:UIVisualEffect!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        bgv.layer.cornerRadius = 10
        //        addItemView.layer.cornerRadius = 5
        //        addItemView.layer.cornerRadius = 50
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        
        
        
        
    }
    
    func animateIn() {
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
        
        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addItemView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addItemView.alpha = 0
            self.visualEffectView.effect = nil
            
            
        }) { (success:Bool) in
            self.addItemView.removeFromSuperview()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: WasteImageClassifier_1().model) else {
            fatalError("Loading CoreMl model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("O"){
                    self.gifImg.image = UIImage(imageLiteralResourceName: "O.png")
                    self.wastelabel.text = "It's a Organic WASTE"
                    self.bgv.image = UIImage(imageLiteralResourceName: "OR.png")
                    self.readMe(myText: "It's a Organic WASTE")
                    
                }
                if firstResult.identifier.contains("PL") {
                    self.gifImg.image = UIImage(imageLiteralResourceName: "PL.jpg")
                    self.wastelabel.text = "It's a Plastic WASTE"
                    self.bgv.image = UIImage(imageLiteralResourceName: "BLACK.png")
                    self.readMe(myText: "It's a Plastic WASTE")
                }
                if firstResult.identifier.contains("E") {
                    self.gifImg.image = UIImage(imageLiteralResourceName: "E.jpg")
                    self.wastelabel.text = "It's a E-WASTE"
                    self.bgv.image = UIImage(imageLiteralResourceName: "RE.png")
                    self.readMe(myText: "It's a E-WASTE")
                }
                if firstResult.identifier.contains("M") {
                    self.gifImg.image = UIImage(imageLiteralResourceName: "M.jpg")
                    self.wastelabel.text = "It's a Metal WASTE"
                    self.bgv.image = UIImage(imageLiteralResourceName: "OR.png")
                    self.readMe(myText: "It's a Metal WASTE")
                }
                if firstResult.identifier.contains("P") {
                    self.gifImg.image = UIImage(imageLiteralResourceName: "P.jpg")
                    self.wastelabel.text = "It's a Paper WASTE"
                    self.bgv.image = UIImage(imageLiteralResourceName: "BL.png")
                    self.readMe(myText: "It's a Paper WASTE")
                }
                if firstResult.identifier.contains("G") {
                    self.gifImg.image = UIImage(imageLiteralResourceName: "G.jpg")
                    self.wastelabel.text = "It's a Glass WASTE"
                    self.bgv.image = UIImage(imageLiteralResourceName: "GR.png")
                    self.readMe(myText: "It's a Glass WASTE")
                }
                if firstResult.identifier.contains("H") {
                    self.gifImg.image = UIImage(imageLiteralResourceName: "X.png")
                    self.wastelabel.text = "It's not a WASTE"
                    self.bgv.image = UIImage(imageLiteralResourceName: "BR.png")
                    self.readMe(myText: "It's not a WASTE")
                }
            }
            
            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        
        animateIn()
        
    }
    
    
    
    @IBAction func back(_ sender: UIButton) {
        
        animateOut()
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func readMe(myText: String) {
        let utterance = AVSpeechUtterance(string: myText)
        utterance.voice = AVSpeechSynthesisVoice()
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
}

