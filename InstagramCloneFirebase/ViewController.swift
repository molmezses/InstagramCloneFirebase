//
//  ViewController.swift
//  InstagramCloneFirebase
//
//  Created by mustafa ölmezses on 17.05.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        
    }


    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != ""{
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { auth, error in
                
                if error != nil{
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
            
        }else{
            makeAlert(title: "Error!", message: "Null")
        }

        
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if passwordText.text != "" && emailText.text != ""{
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { auth, error in
                
                if error != nil{
                    
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                    
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
            
        }else{
            makeAlert(title: "Error!", message: "Username & Password ?")
        }
        
        
        
    }
    
    
    func makeAlert(title:String , message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
}

