//
//  SettingsViewController.swift
//  InstagramCloneFirebase
//
//  Created by mustafa ölmezses on 17.05.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    


    @IBAction func logoutClicked(_ sender: Any) {
        
        do{
            
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
            
        }catch{
            
            print("Error")
            
        }

        
        
    }
    
}
