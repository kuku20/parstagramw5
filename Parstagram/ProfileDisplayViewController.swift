//
//  ProfileDisplayViewController.swift
//  Parstagram
//
//  Created by Luu, Loc on 10/17/21.
//

import UIKit
import Parse
import AlamofireImage
class ProfileDisplayViewController: UIViewController {
    var posts = [PFObject]()
    @IBOutlet weak var userNameDisplay: UILabel!
    @IBOutlet weak var userImageDisplay: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "Profiles")
//        query.limit = 1
//        query.order(byDescending: "createdAt")
    userNameDisplay.text = PFUser.current()!.username!
        query.whereKey("author", equalTo: PFUser.current()!)
    query.findObjectsInBackground{(posts, error) in
//        print((posts?.count)!)
        if  (posts?.count)! != 0{
            let test = posts![(posts?.count)!-1]
//            print(test["image"])
            let imageFile = test["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            self.userImageDisplay.af_setImage(withURL: url)
        }
    }
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        
            let query = PFQuery(className: "Profiles")
//        query.limit = 1
//        query.order(byDescending: "createdAt")
        userNameDisplay.text = PFUser.current()!.username!
        query.whereKey("author", equalTo: PFUser.current()!)
        query.findObjectsInBackground{(posts, error) in
            if (posts?.count)! != 0{
                print((posts?.count)!)
                let test = posts![(posts?.count)!-1]
                print(test["image"])
                let imageFile = test["image"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!
                self.userImageDisplay.af_setImage(withURL: url)
               
            }
        }

        
        
//        cell.photoView.af_setImage(withURL: url)
        print(PFUser.current()!.username!)
        //PFUser.current()!
//            query.includeKey("author")
//            query.limit = 20
//            query.order(byDescending: "createdAt")
//
//            query.findObjectsInBackground{(profiles, error) in
//                if profiles != nil{
//                    self.userImageDisplay = profiles!
//                }
//            }
            
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
