//
//  ViewController.swift
//  MemeMe
//
//  Created by  Vital Milky on 27.09.16.
//  Copyright © 2016  Vital Milky. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    struct Meme {
        var topText: String
        var bootomText: String
        var image: UIImage
        var memedImage: UIImage
    }

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var Pick: UIButton!
    @IBOutlet weak var Camera: UIButton!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    var activeTextfield: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0,
    ] as [String : Any]
    
    
    
    override func viewDidLoad() {
        
        topTextfield.delegate = self
        topTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.delegate = self
        bottomTextfield.defaultTextAttributes = memeTextAttributes
        declareTextfields()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        Camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
       
        
    }

    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_: UIImagePickerController){
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //imagePickerView.contentMode = .scaleAspectFill
            imagePickerView.image = pickedImage
            declareTextfields()
        }
        
        dismiss(animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.clearsOnBeginEditing = false
        activeTextfield = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func declareTextfields(){
        topTextfield.clearsOnBeginEditing = true
        topTextfield.text = "Top"
        topTextfield.textAlignment = .center
        
        bottomTextfield.clearsOnBeginEditing = true
        bottomTextfield.text = "Bottom"
        bottomTextfield.textAlignment = .center
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (activeTextfield.isEqual(bottomTextfield)){
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height
                }
        }
    }
    
    func generateMemedImag	() -> UIImage{
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func save() {
        let meme = Meme(topText: topTextfield.text!, bootomText: bottomTextfield.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
    }

}

