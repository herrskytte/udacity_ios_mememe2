//
//  ViewController.swift
//  MemeMe1
//
//  Created by Frederik Skytte on 07/12/2018.
//  Copyright © 2018 Frederik Skytte. All rights reserved.
//

import UIKit

class GeneratorViewController: UIViewController {

    let initialTopText = "TOP"
    let initialBottomText = "BOTTOM"
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth:  -2.0
    ]
    
    var shouldMoveToShowKeyboard = false
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setText(topTextField, initialTopText)
        setText(bottomTextField, initialBottomText)
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
    }
    
    func setText(_ textField: UITextField, _ text: String) {
        textField.text = text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Disable share button if no image
        shareButton.isEnabled = memeImage.image != nil
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func toolbarPickAction(_ sender: Any) {
        getImageFromController(source: .photoLibrary)
    }
    
    @IBAction func toolbarTakePictureAction(_ sender: Any) {
        getImageFromController(source: .camera)
    }
    
    private func getImageFromController(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification:Notification) {
        if(shouldMoveToShowKeyboard){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func shareAction(_ sender: Any) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImage.image!, memedImage: generateMemedImage())
        
        let items = [meme.memedImage!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
            // User completed sharing
            self.save(memeToSave: meme)
        }
        present(ac, animated: true)

    }
    
    @IBAction func resetAction(_ sender: Any) {
        topTextField.text = initialTopText
        bottomTextField.text = initialBottomText
        memeImage.image = nil
        shareButton.isEnabled = false
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar again
        bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    // Saving Image here
    func save(memeToSave: Meme) {
        UIImageWriteToSavedPhotosAlbum(memeToSave.memedImage!, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // Added image to Library result
    @objc
    func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Error saving image in library
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your meme is shared and stored in your library", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

// `UIImagePickerControllerDelegate` methods:
extension GeneratorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            memeImage.image = image
            // Enable share button with image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
}

// `UITextFieldDelegate` methods:
extension GeneratorViewController: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField){
        if textField == topTextField {
            shouldMoveToShowKeyboard = false
            if textField.text == initialTopText {
                textField.text = ""
            }
        }
        if textField == bottomTextField {
            shouldMoveToShowKeyboard = true
            if textField.text == initialBottomText {
                textField.text = ""
            }
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

