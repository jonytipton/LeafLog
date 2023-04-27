//
//  detailImageCell.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/25/23.
//

import UIKit

class DetailImageCell: UITableViewCell {

    @IBOutlet var detailImageView: UIImageView!
    @IBOutlet var plantLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib() 
        // Initialization code
        detailImageView.layer.cornerRadius = detailImageView.frame.width / 2
        detailImageView.clipsToBounds = true
        detailImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
