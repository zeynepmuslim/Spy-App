//
//  StoryboardFadeToBlackSegue.swift
//  Spy
//
//  Created by Zeynep Müslim on 4.04.2025.
//


import UIKit
import Foundation

class StoryboardFadeToBlueSegue: UIStoryboardSegue {

  override func perform() {
      guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
      super.perform()
      return
    }
    let overlay = GradientView(superView: window)
    overlay.layer.zPosition = 1
    overlay.alpha = 0.0
    window.addSubview(overlay)
    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
      overlay.alpha = 1.0
//      self.source.view.transform = CGAffineTransform(translationX: 0, y: -self.source.view.frame.width)
    }, completion: { _ in
      self.source.present(self.destination, animated: false, completion: {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
          overlay.alpha = 0.0
        }, completion: { _ in
          overlay.removeFromSuperview()
        })
      })
    })
  }
}
