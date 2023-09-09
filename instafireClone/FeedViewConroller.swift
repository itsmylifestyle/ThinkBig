//
//  FeedViewConroller.swift
//  instafireClone
//
//  Created by Айбек on 09.09.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewConroller: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var feedView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var imageArray = [String]()
    
    var documentIDArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedView.delegate = self
        feedView.dataSource = self

        // Do any additional setup after loading the view.
        
        getDataFromFirebase()
    }
    
    func getDataFromFirebase() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(titleInpit: "Error!", messageInput: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIDArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("PostComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageurl = document.get("imageURL") as? String {
                            self.imageArray.append(imageurl)
                        }
                    }
                    self.feedView.reloadData()
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.usernameLabel.text = userEmailArray[indexPath.row]
        cell.likeCounter.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.uiimageView.sd_setImage(with: URL(string: self.imageArray[indexPath.row]))
        cell.documentIDlabel.text = documentIDArray[indexPath.row]
        return cell
    }
    
    func makeAlert(titleInpit: String, messageInput: String) {
        let alert = UIAlertController(title: titleInpit, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okBut = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okBut)
        self.present(alert, animated: true, completion: nil)
    }
}
