//
//  CustomButton.swift
//  Spy
//
//  Created by Zeynep Müslim on 4.03.2025.
//

import UIKit

enum GradientColor {
    case blue
    case red
    case gray
    
    var colors: [CGColor] {
        switch self {
        case .blue:
            return [UIColor.spyBlue01G.cgColor, UIColor.spyBlue02G.cgColor]
        case .red:
            return [UIColor.spyRed01G.cgColor, UIColor.spyRed02G.cgColor]
        case .gray:
            return [UIColor.spyGray01G.cgColor, UIColor.spyGray02G.cgColor]
        }
    }
}
 
class AnimatedGradientView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    init(width: CGFloat, height: CGFloat, gradient: GradientColor) {
        super.init(frame: .zero)
        setupGradient(colors: gradient.colors)
        animateGradientColors(colors: gradient.colors)
        setupSize(width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradient(colors: [CGColor]) {
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        layer.addSublayer(gradientLayer)
        
        animateGradientRotation()
    }
    
    private func setupSize(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         
        gradientLayer.frame = CGRect(x: -bounds.width, y: -bounds.height, width: bounds.width * 3, height: bounds.height * 3)
    }
    
    private func animateGradientRotation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 5.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        gradientLayer.add(rotationAnimation, forKey: "rotation")
    }
    
    func animateGradientColors(colors: [CGColor]) {
        let colorChange = CABasicAnimation(keyPath: "colors")
        colorChange.fromValue = colors
        colorChange.toValue = colors.reversed()
        colorChange.duration = 3.0
        colorChange.autoreverses = true
        colorChange.repeatCount = .infinity
        colorChange.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        gradientLayer.add(colorChange, forKey: "colorChange")
    }
}
