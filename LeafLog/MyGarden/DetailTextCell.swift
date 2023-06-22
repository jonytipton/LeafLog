//
//  detailTextCell.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/25/23.
//

import UIKit

class DetailTextCell: UITableViewCell {

    @IBOutlet var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        detailLabel.font = UIFont(name: "Futura", size: 18)!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
