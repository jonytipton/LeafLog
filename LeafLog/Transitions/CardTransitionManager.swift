//
//  CardTransitionManager.swift
//
//  Created by Jonathan Tipton on 6/20/23.
//

import Foundation
import UIKit

enum CardTransitionType {
    case presentation
    case dismissal
    
    var blurAlpha: CGFloat { return self == .presentation ? 1 : 0 }
    var dimAlpha: CGFloat { return self == .presentation ? 0.5: 0 }
    var cornerRadius: CGFloat { return self == .presentation ? 20.0 : 0 }
    var cardMode: CardViewMode { return self == .presentation ? .card : .full }
    var next: CardTransitionType { return self == .presentation ? .dismissal : .presentation }
}

class CardTransitionManager: NSObject {
    
    var transitionDuration: Double = 0.8
    var transition: CardTransitionType = .presentation
    var shrinkDuration: Double = 0.2
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        return visualEffectView
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //MARK: Helper Methods -
    private func addBackgroundViews(to containerView: UIView) {
        blurEffectView.frame = containerView.frame
        blurEffectView.alpha = transition.next.blurAlpha
        containerView.addSubview(blurEffectView)
        
        dimmingView.frame = containerView.frame
        dimmingView.alpha = transition.next.dimAlpha
        containerView.addSubview(dimmingView)
    }
    
    private func createCardViewCopy(cardView: CardView) -> CardView {
        let cardModel = cardView.cardModel
        cardModel.viewMode = transition.cardMode
        let appView = AppView(cardView.appView?.viewModel)
        let cardViewCopy = CardView(cardModel: cardModel, appView: appView)
        
        return cardViewCopy
    }
}

extension CardTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        
        addBackgroundViews(to: containerView)
        
        let fromView = transitionContext.viewController(forKey: .from)
        let toView = transitionContext.viewController(forKey: .to)
        
        guard let cardView = (transition == .presentation) ? (fromView as! TodayView).selectedCellCardView() :
                (toView as! TodayView).selectedCellCardView()
        else { return }
        
        let cardViewCopy = createCardViewCopy(cardView: cardView)
        containerView.addSubview(cardViewCopy)
        cardView.isHidden = true
        
        let absoluteCardViewFrame = cardView.convert(cardView.frame, to: nil) // converts a point from the receiver's coordinate system to that of the specified view. Pass in nil will get the card view's location relative to the Today view
        cardViewCopy.frame = absoluteCardViewFrame
        cardViewCopy.layoutIfNeeded()
        
        whiteView.frame = transition == .presentation ? cardViewCopy.containerView.frame : containerView.frame
        whiteView.layer.cornerRadius = transition.cornerRadius
        cardViewCopy.insertSubview(whiteView, aboveSubview: cardViewCopy.shadowView)
        
        
        if transition == .presentation {
            let detailView = toView as! DetailView
            containerView.addSubview(detailView.view)
            detailView.viewsAreHidden = true
            
            moveAndConvertToCardView(cardView: cardViewCopy, containerView: containerView, yOriginToMoveTo: 0) {
                detailView.viewsAreHidden = false
                cardViewCopy.removeFromSuperview()
                cardView.isHidden = false
                detailView.createSnapshotOfView()
                transitionContext.completeTransition(true)
            }
        } else {
            let detailView = fromView as! DetailView
            detailView.viewsAreHidden = true
            
            cardViewCopy.frame = CGRect(x: 0, y: 0, width: (detailView.cardView?.frame.size.width)!, height: (detailView.cardView?.frame.size.height)!)
            
            moveAndConvertToCardView(cardView: cardViewCopy, containerView: containerView, yOriginToMoveTo: absoluteCardViewFrame.origin.y) {
                cardView.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
    }
    
    func makeShrinkAnimator(for cardView: CardView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: shrinkDuration, curve: .easeOut) {
            cardView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.dimmingView.alpha = 0.05
        }
    }
    
    func makeExpandContractAnimator(for cardView: CardView, in containerView: UIView, yOrigin: CGFloat) -> UIViewPropertyAnimator {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 4))
        let animator = UIViewPropertyAnimator(duration: transitionDuration - shrinkDuration, timingParameters: springTiming)
        
        animator.addAnimations {
            cardView.transform = .identity
            cardView.containerView.layer.cornerRadius = self.transition.next.cornerRadius
            cardView.frame.origin.y = yOrigin
            
            self.blurEffectView.alpha = self.transition.blurAlpha
            self.dimmingView.alpha = self.transition.dimAlpha
            
            self.whiteView.layer.cornerRadius = self.transition.next.cornerRadius
            
            containerView.layoutIfNeeded()
            
            self.whiteView.frame = self.transition == .presentation ? containerView.frame : cardView.containerView.frame
        }
        
        return animator
    }
    
    func moveAndConvertToCardView(cardView: CardView, containerView: UIView, yOriginToMoveTo: CGFloat, completion: @escaping () -> ()) {
        
        let shrinkAnimator = makeShrinkAnimator(for: cardView)
        let expandContractAnimator = makeExpandContractAnimator(for: cardView, in: containerView, yOrigin: yOriginToMoveTo)
        
        expandContractAnimator.addCompletion{ _ in
            completion()
        }
        
        if transition == .presentation {
            shrinkAnimator.addCompletion { _ in
                cardView.layoutIfNeeded()
                cardView.updateLayout(for: self.transition.next.cardMode)
                expandContractAnimator.startAnimation()
            }
            shrinkAnimator.startAnimation()
        } else {
            cardView.layoutIfNeeded()
            cardView.updateLayout(for: self.transition.next.cardMode)
            expandContractAnimator.startAnimation()
        }
        
        
        
        
        
    }
    
}

extension CardTransitionManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .presentation
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .dismissal
        return self
    }
}
