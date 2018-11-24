//
//  ViewController.swift
//  identify
//
//  Created by Ashutosh Sharma on 15/08/18.
//  Copyright © 2018 BondVending. All rights reserved.
//

import UIKit //import User Interface module
import CoreML //import Machine Learning module
import Vision //import module for image processing
import Social //import social module for sharing results

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    // delegates in Class for functions
    
    @IBOutlet weak var imageView: UIImageView! //image view outlet for image display
    
    let imagePicker = UIImagePickerController()
    //imagrPicker constant for picking or capturing the image
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self //setup image picker delegate function to auto change
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // this function create UIImage to CIImage
        if let pickedImage = info[UIImagePickerControllerEditedImage ] as? UIImage{
            
            imageView.image = pickedImage
            
            guard let ciimage = CIImage(image: pickedImage) else{
                
                fatalError("Unable to Convert the UIImage into CIImage") //error message
                
            }
            
            detect(image: ciimage) // detect that UIImage is Converted into CIImage
            
            
        }
        imagePicker.dismiss(animated: true, completion: nil) // Dismiss the imagePicker after completion of picking image
        
    }
    
    func detect(image: CIImage){
        // Load the ML model through its generated class
        
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else{
            
            fatalError("Loading CoreMLModel Failed")
            
        }
        
        let request = VNCoreMLRequest(model: model) { (request, errorr) in
            // activate the request for predicting the image
            guard let result = request.results?.first as? VNClassificationObservation else{
                // the constant result shows the first and the most confident prediction of object
                fatalError("Model Failed to process image")
                
            }
            let topResult = result.identifier.capitalized
            
            self.navigationItem.title = topResult //display result on anvigation title bar
            
            self.navigationController?.navigationBar.barTintColor = UIColor.white //setup color of title bar
            
            self.navigationController?.navigationBar.isTranslucent = true //make the title bar opaque
            
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        // image handler for conversion
        do{
            
            try handler.perform([request])
            
        }
            
        catch{
            
            print(error)
            
        }
        
    }
    
    
    @IBAction func addPhoto(_ sender: Any) {
        // Input Button Action for picking the photo from image library
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.allowsEditing  = true
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func cameraOpen(_ sender: Any) {
        // Input button Action for opening the camera
        imagePicker.sourceType =  .camera
        
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}



