//
//  detailSlideshowCell.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/25/23.
//

import UIKit

class DetailReferenceCell: UITableViewCell {
    
    @IBOutlet var referenceImageView: UIImageView!
    var cornerRadius: CGFloat = 25
    
    override func awakeFromNib() {
        super.awakeFromNib()
        referenceImageView.layer.cornerRadius = cornerRadius
        referenceImageView.layer.masksToBounds = true
    }

}
