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
    var padding: CGFloat = 15
    var cornerRadius: CGFloat = 25
    var currentPage = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageScrollView.delegate = self
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    func displayImages() {
        for (index,image) in images.enumerated() {
            let view = UIImageView(image: image)
            view.contentMode = .scaleAspectFill
            view.frame = CGRect(x: imageScrollView.frame.width * CGFloat(index) + padding, y: padding, width: imageScrollView.frame.width - (2 * padding), height: imageScrollView.frame.height - (2 * padding))
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
            scrollContentView.addSubview(view)
            scrollContentView.widthAnchor.constraint(equalToConstant: imageScrollView.frame.width * CGFloat(images.count)).isActive = true
            imageScrollView.isPagingEnabled = true
        }
    }
}
