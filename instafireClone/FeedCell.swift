//
//  FeedCell.swift
//  instafireClone
//
//  Created by Айбек on 10.09.2023.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var uiimageView: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var likeCounter: UILabel!
    
    
    @IBOutlet weak var documentIDlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeCounter.text!) {
            
            let likePost = ["likes" : likeCount + 1] as [String : Any]
            
            firestoreDatabase.collection("Posts").document(documentIDlabel.text!).setData(likePost, merge: true)
        }
        
    }
    

}
