//
//  detailSlideshowCell.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/25/23.
//

import UIKit

class DetailSlideshowCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet var imageScrollView: UIScrollView!
    
    @IBOutlet var scrollContentView: UIView!
    
    var images: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
    }

    
    func displayImages() {
        for (index,image) in images.enumerated() {
            let view = UIImageView(image: image)
            view.contentMode = .scaleAspectFill
            view.frame = CGRect(x: imageScrollView.frame.width * CGFloat(index), y: 0, width: imageScrollView.frame.width, height: imageScrollView.frame.height)
            scrollContentView.addSubview(view)
            scrollContentView.widthAnchor.constraint(equalToConstant: imageScrollView.frame.width * CGFloat(images.count)).isActive = true
            scrollContentView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        }
    }
}
