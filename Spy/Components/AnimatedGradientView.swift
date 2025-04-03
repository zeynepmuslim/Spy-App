import UIKit
 
class AnimatedGradientView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    init(width: CGFloat, height: CGFloat, gradient: GradientColor) {
        super.init(frame: .zero)
        setupGradient(colors: gradient.colors)
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
               let maxSide = max(bounds.width, bounds.height)
        let scaledSize = maxSide * 1.3
               
               gradientLayer.frame = CGRect(
                   x: bounds.midX - scaledSize / 2,
                   y: bounds.midY - scaledSize / 2,
                   width: scaledSize,
                   height: scaledSize
               )
               
               gradientLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func animateGradientRotation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 5.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        gradientLayer.add(rotationAnimation, forKey: "rotation")
    }
    
    func updateGradient(to gradient: GradientColor) {
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.fromValue = gradientLayer.colors
        colorAnimation.toValue = gradient.colors
        colorAnimation.duration = GeneralConstants.Animation.duration
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        gradientLayer.add(colorAnimation, forKey: "colorChange")
        gradientLayer.colors = gradient.colors
    }
}
