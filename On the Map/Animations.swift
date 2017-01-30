//
//  Animations.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 30.01.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

fileprivate protocol AnimationView {
    static func hide(view: UIView, alpha: Int)
}

final class Animations: AnimationView {
    static func hide(view: UIView, alpha: Int) {
        let duration = 0.5
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0,
                       options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState],
                       animations:  {
                        view.alpha = CGFloat(alpha)
        }, completion: {(bool) in
            view.removeFromSuperview()
        })
    }
}
