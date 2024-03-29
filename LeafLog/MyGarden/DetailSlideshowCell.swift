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
    @IBOutlet var pageControl: UIPageControl!
        
    var images: [UIImage] = [] {
        didSet {
            displayImages()
        }
    }
    var padding: CGFloat = 5
    var cornerRadius: CGFloat = 25
    var currentPage: Int = 0
    var awaitingDisplay = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageScrollView.delegate = self
        imageScrollView.showsHorizontalScrollIndicator = false
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = currentPage
    }
    
    func displayImages() {
        guard awaitingDisplay else { return }
        for (index,image) in images.enumerated() {
            let view = UIImageView(image: image)
            view.contentMode = .scaleAspectFill
            view.frame = CGRect(x: imageScrollView.frame.width * CGFloat(index) + padding, y: 0, width: imageScrollView.frame.width - (2 * padding), height: imageScrollView.frame.height - (6 * padding))
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
            scrollContentView.addSubview(view)
        }
        imageScrollView.isPagingEnabled = true
        imageScrollView.clipsToBounds = false
        scrollContentView.removeConstraints(scrollContentView.constraints)
        scrollContentView.widthAnchor.constraint(equalToConstant: imageScrollView.frame.width * CGFloat(images.count)).isActive = true
        
        configurePageControl()
        awaitingDisplay = false
    }
    
    func configurePageControl() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = currentPage
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor(named: "titleColor")?.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = UIColor(named: "titleColor")
    }
}
