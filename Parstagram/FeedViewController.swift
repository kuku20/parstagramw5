//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Luu, Loc on 10/6/21.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate{
    
    
    var posts = [PFObject]()
    @IBOutlet var tableView: UITableView!
    let commentBar = MessageInputBar()
    var showCommentBar = false
    var selectedPost: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentBar.inputTextView.placeholder = "Add a comment...."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBehidden), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    @objc func keyboardWillBehidden(note: Notification){
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    override var canBecomeFirstResponder: Bool{
        return showCommentBar
    }
    
    
    // Do any additional setup after loading the view.
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            let query = PFQuery(className: "Posts")
            query.includeKeys(["author", "comments", "comments.author"])
            query.limit = 20
            query.order(byDescending: "createdAt")

            query.findObjectsInBackground{(posts, error) in
                if posts != nil{
                    self.posts = posts!
                    self.tableView.reloadData()
                }
            }
            
        }
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //create the commnet
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")

        selectedPost.saveInBackground{ (sucess , error) in
            if sucess{
                print("Comment Saved")
            }else{
                print("Error saving comment")
            }
        }
        
        tableView.reloadData()
        
        
        
        //clear and dismis
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let post = posts[section]
            let comments = (post["comments"] as? [PFObject]) ?? []
            return comments.count + 2
        }
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let post = posts[indexPath.section]
            let comments = (post["comments"] as? [PFObject]) ?? []
            print(comments)
            if indexPath.row == 0 {
                
            
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
                
               
                let user = post["author"] as! PFUser
                cell.usernameLable.text = user.username
                cell.captionLable.text = post["caption"] as! String
                
                let imageFile = post["image"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!
                
                cell.photoView.af_setImage(withURL: url)
                
                let query = PFQuery(className: "Profiles")
            query.whereKey("author", equalTo: user)
            query.findObjectsInBackground{(posts, error) in
                if (posts?.count)! != 0{
                    print((posts?.count)!)
                    let test = posts![(posts?.count)!-1]
                    let imageFile = test["image"] as! PFFileObject
                    let urlString = imageFile.url!
                    let url = URL(string: urlString)!
                    cell.userProfile.af_setImage(withURL: url)
                   
                }
            }
                
                
                
                
                
                
                
                return cell
            }else if indexPath.row <= comments.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
                let comment = comments[indexPath.row - 1]
                cell.commentLabel.text = comment["text"] as? String
                let user = comment["author"] as! PFUser
                cell.nameLabel.text = user.username
                
                
                let query = PFQuery(className: "Profiles")
            query.whereKey("author", equalTo: user)
            query.findObjectsInBackground{(posts, error) in
                if (posts?.count)! != 0{
                    print((posts?.count)!)
                    let test = posts![(posts?.count)!-1]
                    let imageFile = test["image"] as! PFFileObject
                    let urlString = imageFile.url!
                    let url = URL(string: urlString)!
                    cell.commentProfile.af_setImage(withURL: url)

                }
            }
                
                
                
                
                
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier:    "AddCommentCell")!
                return cell
            }
            
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        
        let comments = (post["comments"] as? [PFObject]) ?? []

        
        if indexPath.row == comments.count+1 {
            showCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
            
        }
        //        comment["text"] = "This is a random comment"
//        comment["post"] = post
//        comment["author"] = PFUser.current()!
//
//        post.add(comment, forKey: "comments")
//
//        post.saveInBackground{ (sucess , error) in
//            if sucess{
//                print("Comment Saved")
//            }else{
//                print("Error saving comment")
//            }
//        }
    }
    @IBAction func onLogOut(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = loginViewController
//       guard let delegate = UIApplication.shared.delegate as! AppDelegate
//        delegate.window?.rootViewController = loginViewController
//        var currentUser = PFUser.current()
//        dismiss(animated: true, completion: nil)
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
