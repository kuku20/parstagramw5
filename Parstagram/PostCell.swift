//
//  PostCell.swift
//  Parstagram
//
//  Created by Luu, Loc on 10/6/21.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var captionLable: UILabel!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
