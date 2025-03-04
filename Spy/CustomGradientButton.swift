//
//  CustomButton.swift
//  Spy
//
//  Created by Zeynep Müslim on 4.03.2025.
//

import UIKit

class CustomGradientButton: UIView {
    private let gradientColor: GradientColor
    private let width: CGFloat
    private let height: CGFloat
    private let innerCornerRadius: CGFloat
    private let outherCornerRadius: CGFloat
    private let shadowColor: ShadowColor
    private let borderWidth: CGFloat
    
    enum ShadowColor {
          case red
          case blue
          case gray
          
          var cgColor: CGColor {
              switch self {
              case .red:
                  return UIColor.spyRed01.cgColor
              case .blue:
                  return UIColor.spyBlue01.cgColor
              case .gray:
                  return UIColor.spyGray01.cgColor
              }
          }
      }
    
    init(gradientColor: GradientColor = .blue, width: CGFloat = 150, height: CGFloat = 50, innerCornerRadius: CGFloat = 8, outherCornerRadius: CGFloat = 10, shadowColor: ShadowColor = .red, borderWidth: CGFloat = 5) {
        self.gradientColor = gradientColor
        self.width = width
        self.height = height
        self.innerCornerRadius = innerCornerRadius
        self.outherCornerRadius = outherCornerRadius
        self.shadowColor = shadowColor
        self.borderWidth = borderWidth
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.gradientColor = .blue
        self.width = 150
        self.height = 50
        self.innerCornerRadius = 8
        self.outherCornerRadius = 10
        self.shadowColor = .red
        self.borderWidth = 5
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        let firstView = UIView()
        firstView.backgroundColor = .spyBlue04
        firstView.layer.cornerRadius = innerCornerRadius
        
        let gradientAnimationBorder = AnimatedGradientView(width: width, height: height, gradient: gradientColor)
        gradientAnimationBorder.layer.cornerRadius = outherCornerRadius
        gradientAnimationBorder.clipsToBounds = true
        
        let thirdView = UIView()
        thirdView.backgroundColor = .gray
        thirdView.layer.shadowColor = shadowColor.cgColor
        thirdView.layer.shadowOpacity = 1.0
        thirdView.layer.shadowOffset = CGSize(width: 0, height: 1)
        thirdView.layer.shadowRadius = outherCornerRadius
        thirdView.layer.cornerRadius = outherCornerRadius
        
        addSubview(thirdView)
        addSubview(gradientAnimationBorder)
        addSubview(firstView)
        
        gradientAnimationBorder.translatesAutoresizingMaskIntoConstraints = false
        firstView.translatesAutoresizingMaskIntoConstraints = false
        thirdView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradientAnimationBorder.topAnchor.constraint(equalTo: topAnchor),
            gradientAnimationBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientAnimationBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientAnimationBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            firstView.topAnchor.constraint(equalTo: gradientAnimationBorder.topAnchor, constant: borderWidth),
            firstView.leadingAnchor.constraint(equalTo: gradientAnimationBorder.leadingAnchor, constant: borderWidth),
            firstView.trailingAnchor.constraint(equalTo: gradientAnimationBorder.trailingAnchor, constant: -borderWidth),
            firstView.bottomAnchor.constraint(equalTo: gradientAnimationBorder.bottomAnchor, constant: -borderWidth),
            
            thirdView.topAnchor.constraint(equalTo: gradientAnimationBorder.topAnchor),
            thirdView.leadingAnchor.constraint(equalTo: gradientAnimationBorder.leadingAnchor),
            thirdView.trailingAnchor.constraint(equalTo: gradientAnimationBorder.trailingAnchor),
            thirdView.bottomAnchor.constraint(equalTo: gradientAnimationBorder.bottomAnchor),
        ])
    }
}
