//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Luu, Loc on 10/17/21.
//

import UIKit
import AlamofireImage
import Parse

class ProfileViewController: UIViewController,
                             UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var profileView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSubmitProfile(_ sender: Any) {
        let profile = PFObject(className: "Profiles")

        let imageData = profileView.image!.pngData()
        let file = PFFileObject(name:"image.png",data: imageData!)
        profile["image"] = file

        profile["author"] = PFUser.current()!
        profile.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
                self.dismiss(animated: true, completion: nil)
                print("Saved")
            } else {
                // There was a problem, check error.description
                print("error!")
            }
        }
    }
   
     @IBAction func onCameraProfile(_ sender: Any) {
         let picker = UIImagePickerController()
         picker.delegate = self
         picker.allowsEditing = true
         
         if UIImagePickerController.isSourceTypeAvailable(.camera){
             picker.sourceType = .camera
             
         }else{
             picker.sourceType = .photoLibrary
             
         }
         present(picker, animated: true, completion: nil)
         
     }
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         let image = info[.editedImage] as! UIImage
         //resize import alamo
         let size = CGSize(width: 300, height: 300)
         let scaledImage = image.af_imageScaled(to: size)
         profileView.image = scaledImage
         dismiss(animated: true, completion: nil)
         
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
