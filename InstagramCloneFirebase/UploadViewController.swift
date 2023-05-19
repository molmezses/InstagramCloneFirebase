//
//  UploadViewController.swift
//  InstagramCloneFirebase
//
//  Created by mustafa ölmezses on 17.05.2023.
//

import UIKit
import Firebase
import FirebaseStorage


class UploadViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    @IBOutlet weak var commandText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    

    
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
 
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media") // media klasörüne git
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString// her seferibde aynı remsin ğzerine kaydetmemems iiçin uuid veriyoruz
            
            let imageReference = mediaFolder.child("\(uuid).jpg") //her seferibde aynı remsin ğzerine kaydetmemems iiçin uuid veriyoruz
            imageReference.putData(data , metadata: nil) { metadata, error in
                
                if error != nil{
                    self.makeAlert(title: "Error", message: error?.localizedDescription ??  "Error")
                }else{
                    
                    imageReference.downloadURL { url, error in
                        
                        if error == nil{
                            
                            let imageUrl =  url?.absoluteString
                            
                            
                            //DATABASE
                            
                         
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageUrl , "PostedBy" : Auth.auth().currentUser!.email! , "postComment" : self.commandText.text! , "date": FieldValue.serverTimestamp() , "likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost , completion: { error in
                                
                                if error != nil{
                                  
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                    
                                }else{
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commandText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            
                            })
                            
                            
                            
                                
                        }
                    }
                }
            }
        }
        
        
    }//savebutton clicked
    
    func makeAlert(title:String , message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    
    
    
    
    
}
