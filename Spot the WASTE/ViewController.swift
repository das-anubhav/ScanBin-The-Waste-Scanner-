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


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
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
            
//            if let firstResult = results.first {
//                if firstResult.identifier.contains("hotdog"){
//                    self.navigationItem.title = "Hotdog!"
//                }
//                else {
//                    self.navigationItem.title = "Not a Hotdog!"
//                }
//            }
            
            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        
    }
    
    
    
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        
        
        present(imagePicker, animated: true, completion: nil)
        
    }
}

