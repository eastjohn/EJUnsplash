//
//  ListViewCell.swift
//  EJUnsplash
//
//  Created by John on 2020/12/11.
//

import UIKit

class ListViewCell: UITableViewCell {
    static let Identifier = "ListViewCell"

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var photoImage: UIImage? {
        get {
            return photoImageView?.image
        }
        set {
            photoImageView?.image = newValue
        }
    }
    
    var name: String? {
        get {
            return nameLabel?.text
        }
        set {
            nameLabel?.text = newValue
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name = nil
        photoImage = nil
    }

}
