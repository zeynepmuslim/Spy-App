//
//  GradiendBackgorunda.swift
//  Spy
//
//  Created by Zeynep Müslim on 4.03.2025.
//

import UIKit

class GradientView: UIView {
    init(superView: UIView) {
            super.init(frame: superView.bounds) // Super view’in frame’ini al
            setupGradient()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupGradient() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor.spyBlue03.cgColor,
                UIColor.spyBlue04.cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.frame = bounds
            layer.insertSublayer(gradientLayer, at: 0)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            frame = superview?.bounds ?? .zero 
            layer.sublayers?.first?.frame = bounds
        }
}
