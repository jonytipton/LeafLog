//
//  detailImageCell.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/25/23.
//

import UIKit

class DetailImageCell: UITableViewCell {

    @IBOutlet var detailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib() 
        // Initialization code
        detailImageView.clipsToBounds = true
        detailImageView.contentMode = .scaleAspectFill
        detailImageView.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
