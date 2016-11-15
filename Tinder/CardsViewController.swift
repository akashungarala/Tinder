//
//  CardsViewController.swift
//  Tinder
//
//  Created by Akash Ungarala on 11/14/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import Foundation

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

class CardsViewController: UIViewController {
    
    @IBOutlet weak var bottomCard: DraggableView!
    @IBOutlet weak var draggableStackView: DraggableView!
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    // Save the center points of the view
    var centerX: CGFloat?
    var centerY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareBottomCard()
        prepareStackView()
        prepareActionButtons()
    }
    
    @objc func messageButtonPressed() {
        print("message pressed")
    }
    
    @objc func gearButtonPressed() {
        print("gear pressed")
    }
    
}

extension CardsViewController: DraggableDelegate {
    
    internal func prepareNavigationBar() {
        // Prepare right messages button
        let messageImage = UIImage(named: "tinder_message_icon")
        let messageImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        messageImageview.image = messageImage
        messageImageview.contentMode = .scaleAspectFit
        let messageBarButton = UIBarButtonItem(customView: messageImageview)
        messageBarButton.target = self
        messageBarButton.action = #selector(messageButtonPressed)
        // Prepare settings button
        let gearImage = UIImage(named: "tinder_gear_icon")
        let gearImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        gearImageView.image = gearImage
        gearImageView.contentMode = .scaleAspectFit
        let gearBarButton = UIBarButtonItem(customView: gearImageView)
        gearBarButton.target = self
        gearBarButton.action = #selector(gearButtonPressed)
        // Go ahead and add left and right buttons here
        self.navigationItem.leftBarButtonItem = gearBarButton
        self.navigationItem.rightBarButtonItem = messageBarButton
        // Go ahead and add the logo as the title here
        let logo = UIImage(named: "tinder_logo")
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        logoImageView.image = logo
        logoImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoImageView
    }
    
    internal func prepareBottomCard() {
        bottomCard.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        // Set corner layer
        bottomCard.layer.cornerRadius = 4.0
        // Go ahead and add a shadow to the stackview
        bottomCard.backgroundColor = UIColor.white
        bottomCard.layer.shadowColor = UIColor.black.cgColor
        bottomCard.layer.shadowOpacity = 0.7
        bottomCard.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        bottomCard.layer.shadowRadius = 3.0
    }
    
    internal func prepareStackView() {
        // Set corner layer
        draggableStackView.layer.cornerRadius = 4.0
        // Go ahead and add a shadow to the stackview
        draggableStackView.backgroundColor = UIColor.white
        draggableStackView.layer.shadowColor = UIColor.black.cgColor
        draggableStackView.layer.shadowOpacity = 0.4
        draggableStackView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        draggableStackView.layer.shadowRadius = 3.0
        // Save the center points of the view
        self.centerX = draggableStackView.center.x
        self.centerY = draggableStackView.center.y
        // Go ahead and set our delegate
        draggableStackView.draggableDelegate = self
    }
    
    internal func prepareActionButtons() {}
    
    func onSwipe(sender: UIPanGestureRecognizer) {
        // Grab our values
        let translation = sender.translation(in: draggableStackView)
        let translationX = translation.x
        let translationY = translation.y
        // Go ahead and figure out the event paths
        if sender.state == UIGestureRecognizerState.began {
            // Go ahead and save the original center point of the view
        } else if sender.state == UIGestureRecognizerState.changed {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.75, options: .curveEaseOut, animations: {
                // Go ahead and translate the view, we can do this by changing the center of the view now
                self.draggableStackView.center.x = self.centerX! + translationX
                self.draggableStackView.center.y = self.centerY! + translationY
            }, completion: nil)
            let value = self.centerX! + translationX
            let rescaledValue = self.rescale(domain1: self.centerX!, domain2: self.screenWidth, range1: 0, range2: 15, value: value)
            let radians = rescaledValue.degreesToRadians
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.draggableStackView.transform = CGAffineTransform(rotationAngle: radians)
            }, completion: nil)
            let adjustedValue = self.centerX! + (translationX < 0.0 ? translationX * -1 : translationX)
            let scaleValue = self.rescale(domain1: self.centerX!, domain2: self.screenWidth, range1: 0.98, range2: 1.0, value: adjustedValue)
            let absScale = (scaleValue < 0.0) ? scaleValue * -1 : scaleValue
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.bottomCard.transform = CGAffineTransform(scaleX: absScale, y: absScale)
            }, completion: nil)
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 1.2, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.50, options: .curveEaseOut, animations: {
                // Go ahead and translate the view, we can do this by changing the center of the view now
                self.draggableStackView.center.x = self.centerX!
                self.draggableStackView.center.y = self.centerY!
                self.draggableStackView.transform = CGAffineTransform.identity
            }, completion: nil)
            UIView.animate(withDuration: 1.2, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.50, options: .curveEaseOut, animations: {
                self.bottomCard.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    internal func rescale(domain1: CGFloat, domain2: CGFloat, range1: CGFloat, range2: CGFloat, value: CGFloat) -> CGFloat {
        return interpolate(range1: range1, range2: range2, value: uninterpolate(domain1: domain1, domain2: domain2, value: value))
    }
    
    
    internal func interpolate(range1: CGFloat, range2: CGFloat, value: CGFloat) -> CGFloat {
        return range1 * (1 - value) + range2 * value
    }
    
    internal func uninterpolate(domain1: CGFloat, domain2: CGFloat, value: CGFloat) -> CGFloat {
        let b = (domain2 - domain1) != 0 ? domain2 - domain1 : 1 / domain2
        return (value - domain1) / b
    }

}
