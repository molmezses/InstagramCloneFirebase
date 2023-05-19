//
//  FeedViewController.swift
//  InstagramCloneFirebase
//
//  Created by mustafa ölmezses on 17.05.2023.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage


class FeedViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var userImageArray = [String]()
    var likeArray = [Int]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
    }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userEmailArray.count
        }
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell // burdaki cell mainde soldaki identifer olan sell
            cell.userEmailLabel.text = userEmailArray[indexPath.row]
            cell.likeLabel.text = String(likeArray[indexPath.row])
            cell.commentLabel.text = userCommentArray[indexPath.row]
            //SDWebImage GİThuB KĞĞTHANESİ
            cell.userImageView.sd_setImage(with:URL(string: self.userImageArray[indexPath.row]))
            cell.documentIdLabel.text=documentIdArray[indexPath.row]
            return cell
        }
    
        
    func getDataFromFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                print("fsfsdf")
            }else{
                if snapshot?.isEmpty != true {
                    
                    //Verilerin teableviewde tekrarlanmaması için arrayleri temizle kodlu
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)

                        
                    for document in snapshot!.documents{
                        
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("PostedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let imageURL = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageURL)
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    
        
        
        
        
        
        
        
    }
