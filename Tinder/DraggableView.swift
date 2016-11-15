//
//  DraggableView.swift
//  Tinder
//
//  Created by Akash Ungarala on 11/14/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit

protocol DraggableDelegate {
    func onSwipe(sender: UIPanGestureRecognizer)
}

class DraggableView: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLocationLabel: UILabel!
    
    var draggableDelegate: DraggableDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        preparePanGesture()
    }
    
    @objc func objectSwiped(sender: UIPanGestureRecognizer) {
        // Go ahead and pass events back to the view controller
        if draggableDelegate != nil {
            draggableDelegate?.onSwipe(sender: sender)
        }
    }
    
}

extension DraggableView {
    
    internal func preparePanGesture() {
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(objectSwiped(sender:)))
        self.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    internal func prepareImage() {
        let image = UIImage(named: "Akash")
        profileImageView.image = image
        profileImageView.contentMode = .scaleAspectFill
    }
    
}
