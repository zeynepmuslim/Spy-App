import UIKit
import SwiftUI

protocol CustomCardViewDelegate: AnyObject {
    func cardViewWasDismissed(_ cardView: CustomCardView)
}

class CustomCardView: UIView {
    
    weak var delegate: CustomCardViewDelegate?
    private var initialCenter: CGPoint = .zero
    private var originalTransform: CGAffineTransform = .identity
    
    var isInteractionEnabled: Bool = false {
        didSet {
            isUserInteractionEnabled = isInteractionEnabled
        }
    }
    
    var gradientColor: GradientColor
    var width: CGFloat
    var height: CGFloat
    var innerCornerRadius: CGFloat
    var outherCornerRadius: CGFloat
    var shadowColor: ShadowColor
    var borderWidth: CGFloat
    var isBorderlessButton: Bool
    var labelText: String {
        didSet {
            titleLabel.text = labelText
            animateLabelChange()
        }
    }
    
    // VİEWWW
    private let firstView = UIView()
    private let thirdView = UIView()
    private let titleLabel = UILabel()
    private var firstViewTopConstraint: NSLayoutConstraint!
    private var firstViewBottomConstraint: NSLayoutConstraint!
    private var firstViewLeadingConstraint: NSLayoutConstraint!
    private var firstViewTrailingConstraint: NSLayoutConstraint!
    private var gradientAnimationBorder: AnimatedGradientView!
    private var currentAnimator: UIViewPropertyAnimator?
    
    private let maxRotation: CGFloat = .pi / 10
    private let throwVelocityThreshold: CGFloat = 1000
    private let dismissalThreshold: CGFloat = 0.4
    
    private var status: ButtonStatus = .activeBlue {
        didSet {
            updateAppearance(shadowColor: status.shadowColor, gradientColor: status.gradientColor)
        }
    }
    
    // Labels to display content on the card
    private let label1: UILabel = {
        let label = UILabel()
        label.text = "Label 1" // Default text
        label.textAlignment = .center
        label.textColor = .white // Adjust color as needed
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold) // Prominent top label
        label.numberOfLines = 0 // Allow multiple lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.text = "Label 2" // Default text
        label.textAlignment = .center
        label.textColor = .lightGray // Adjust color as needed
        label.font = UIFont.systemFont(ofSize: 18) // Mid-size middle label
        label.numberOfLines = 0 // Allow multiple lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let label3: UILabel = {
        let label = UILabel()
        label.text = "Label 3" // Default text
        label.textAlignment = .center
        label.textColor = .lightGray // Adjust color as needed
        label.font = UIFont.systemFont(ofSize: 16) // Smaller bottom label
        label.numberOfLines = 0 // Allow multiple lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(labelText: String = "Hiii", gradientColor: GradientColor = .blue, width: CGFloat = GeneralConstants.Button.defaultWidth, height: CGFloat = GeneralConstants.Button.defaultHeight, innerCornerRadius: CGFloat = GeneralConstants.Button.innerCornerRadius, outherCornerRadius: CGFloat = GeneralConstants.Button.outerCornerRadius, shadowColor: ShadowColor = .blue, borderWidth: CGFloat = GeneralConstants.Button.borderWidth, fontSize: CGFloat = GeneralConstants.Font.size04, isBorderlessButton: Bool = false) {
        self.gradientColor = gradientColor
        self.width = width
        self.height = height
        self.innerCornerRadius = innerCornerRadius
        self.outherCornerRadius = outherCornerRadius
        self.shadowColor = shadowColor
        self.borderWidth = borderWidth
        self.labelText = labelText
        self.isBorderlessButton = isBorderlessButton
        super.init(frame: .zero)
        setupView(fontSize: fontSize)
        setupLabels()
        setupGestures()
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        self.gradientColor = .blue
        self.width = GeneralConstants.Button.defaultWidth
        self.height = GeneralConstants.Button.defaultHeight
        self.innerCornerRadius = GeneralConstants.Button.innerCornerRadius
        self.outherCornerRadius = GeneralConstants.Button.outerCornerRadius
        self.shadowColor = .red
        self.borderWidth = GeneralConstants.Button.borderWidth
        self.labelText = "Button"
        self.isBorderlessButton = false
        super.init(coder: coder)
        setupView(fontSize: GeneralConstants.Font.size04)
        setupLabels()
        setupGestures()
        isUserInteractionEnabled = false
    }
    
    // MARK: - Setup
    private func setupView(fontSize: CGFloat) {
        firstView.backgroundColor = .spyBlue04
        firstView.layer.cornerRadius = innerCornerRadius
        firstView.isHidden = isBorderlessButton
        
        gradientAnimationBorder = AnimatedGradientView(width: width, height: height, gradient: gradientColor)
        gradientAnimationBorder.layer.cornerRadius = outherCornerRadius
        gradientAnimationBorder.clipsToBounds = true
        
        thirdView.backgroundColor = .gray
        thirdView.layer.shadowColor = shadowColor.cgColor
        thirdView.layer.shadowOpacity = GeneralConstants.Button.shadowOpacity
        thirdView.layer.shadowOffset = CGSize(width: 0, height: 1)
        thirdView.layer.shadowRadius = outherCornerRadius
        thirdView.layer.cornerRadius = outherCornerRadius
        
        titleLabel.text = labelText
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        titleLabel.textAlignment = .center
        
        addSubview(thirdView)
        addSubview(gradientAnimationBorder)
        addSubview(firstView)
        addSubview(titleLabel)
        
        gradientAnimationBorder.translatesAutoresizingMaskIntoConstraints = false
        firstView.translatesAutoresizingMaskIntoConstraints = false
        thirdView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        firstViewTopConstraint = firstView.topAnchor.constraint(equalTo: gradientAnimationBorder.topAnchor, constant: borderWidth)
        firstViewBottomConstraint = firstView.bottomAnchor.constraint(equalTo: gradientAnimationBorder.bottomAnchor, constant: -borderWidth)
        firstViewLeadingConstraint = firstView.leadingAnchor.constraint(equalTo: gradientAnimationBorder.leadingAnchor, constant: borderWidth)
        firstViewTrailingConstraint = firstView.trailingAnchor.constraint(equalTo: gradientAnimationBorder.trailingAnchor, constant: -borderWidth)
        
        NSLayoutConstraint.activate([
            gradientAnimationBorder.topAnchor.constraint(equalTo: topAnchor),
            gradientAnimationBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientAnimationBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientAnimationBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            firstViewTopConstraint,
            firstViewLeadingConstraint,
            firstViewTrailingConstraint,
            firstViewBottomConstraint,
            
            thirdView.topAnchor.constraint(equalTo: gradientAnimationBorder.topAnchor),
            thirdView.leadingAnchor.constraint(equalTo: gradientAnimationBorder.leadingAnchor),
            thirdView.trailingAnchor.constraint(equalTo: gradientAnimationBorder.trailingAnchor),
            thirdView.bottomAnchor.constraint(equalTo: gradientAnimationBorder.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func setupLabels() {
        addSubview(label1)
        addSubview(label2)
        addSubview(label3)

        // Layout labels using constraints for flexibility
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            label1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            label2.topAnchor.constraint(greaterThanOrEqualTo: label1.bottomAnchor, constant: 15), // Ensure minimum space
            label2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            label2.centerYAnchor.constraint(equalTo: centerYAnchor), // Center label2 vertically if possible

            label3.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            label3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            label3.topAnchor.constraint(greaterThanOrEqualTo: label2.bottomAnchor, constant: 15) // Ensure space below label2
        ])
    }
    
    func setStatus(_ newStatus: ButtonStatus) {
        status = newStatus
    }
    
    func getStatus() -> ButtonStatus {
        return status
    }
    
    
    private func animateLabelChange() {
        UIView.transition(with: titleLabel, duration: GeneralConstants.Animation.duration, options: .transitionCrossDissolve, animations: {
            self.titleLabel.text = self.labelText
        }, completion: nil)
    }
    
    func updateAppearance(shadowColor: ShadowColor, gradientColor: GradientColor) {
        UIView.animate(withDuration: GeneralConstants.Animation.duration, animations: {
            self.shadowColor = shadowColor
            self.thirdView.layer.shadowColor = shadowColor.cgColor
            self.gradientAnimationBorder.updateGradient(to: gradientColor)
        })
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    // Public method to configure labels
    func configure(text1: String, text2: String, text3: String) {
        label1.text = text1
        label2.text = text2
        label3.text = text3
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        switch gesture.state {
        case .began:
            initialCenter = center
            originalTransform = transform
            // Optional: Add subtle lift animation on touch start
            UIView.animate(withDuration: 0.1) {
                self.transform = self.transform.scaledBy(x: 1.02, y: 1.02)
            }
            
        case .changed:
            // Update card position to follow finger
            center = CGPoint(x: initialCenter.x + translation.x,
                           y: initialCenter.y + translation.y)
            
            // Calculate rotation based *only* on horizontal movement relative to center
            let rotationAngle = (center.x - (superview?.bounds.midX ?? 0)) / (superview?.bounds.width ?? 1) * maxRotation
            
            // Apply combined scale (from .began) and rotation
            transform = originalTransform.scaledBy(x: 1.02, y: 1.02).rotated(by: rotationAngle)
            
        case .ended:
            // Check horizontal dismissal criteria
            let horizontalVelocityHigh = abs(velocity.x) > throwVelocityThreshold
            let horizontalMovedFar = abs(translation.x) > bounds.width * dismissalThreshold
            let shouldDismissHorizontally = horizontalVelocityHigh || horizontalMovedFar
            
            // Check vertical dismissal criteria
            let verticalVelocityHigh = abs(velocity.y) > throwVelocityThreshold
            let verticalMovedFar = abs(translation.y) > bounds.height * dismissalThreshold // Use height here
            let shouldDismissVertically = verticalVelocityHigh || verticalMovedFar
            
            if shouldDismissHorizontally || shouldDismissVertically {
                // Pass velocity and translation to determine dismissal direction and animation
                dismissCard(velocity: velocity, translation: translation)
            } else {
                // Return card to original position if not dismissed
                returnToOriginalPosition()
            }
            
        default:
            // For any other state (cancelled, failed):
            returnToOriginalPosition()
        }
    }
    
    private func dismissCard(velocity: CGPoint, translation: CGPoint) {
        // Determine if the primary dismissal direction is vertical
        let isVerticalDismissal = abs(translation.y) > abs(translation.x)
        
        let screenBounds = UIScreen.main.bounds
        
        var finalCenter: CGPoint = center // Start animation from the release point
        var finalTransform: CGAffineTransform = transform // Start animation from release transform
        let finalAlpha: CGFloat = 0
        
        if isVerticalDismissal {
            // Vertical Dismissal
            let directionY: CGFloat = translation.y >= 0 ? 1 : -1 // 1 = down, -1 = up
            finalCenter.y = initialCenter.y + (screenBounds.height * directionY * 1.2) // Further off-screen
            // Reset rotation and scale completely for vertical dismiss
            finalTransform = originalTransform // No rotation or scale on vertical exit

        } else {
            // Horizontal Dismissal
            let directionX: CGFloat = translation.x >= 0 ? 1 : -1 // 1 = right, -1 = left
            finalCenter.x = initialCenter.x + (screenBounds.width * directionX * 1.5) // Further off-screen

            // Apply final rotation based on the horizontal distance, based on original scale
            let finalRotation = (finalCenter.x - initialCenter.x) / bounds.width * maxRotation * 0.8 // Slightly less rotation
            finalTransform = originalTransform.rotated(by: finalRotation) // Rotate from original
        }
        
        // Unified Animation Block
        UIView.animate(withDuration: 0.45, // Consistent duration
                     delay: 0,
                     usingSpringWithDamping: 0.75, // Good springiness
                     initialSpringVelocity: max(abs(velocity.x), abs(velocity.y)) / 1000, // Use dominant velocity
                     options: [.curveEaseOut, .allowUserInteraction]) {
            self.center = finalCenter
            self.transform = finalTransform
            self.alpha = finalAlpha
        } completion: { _ in
            // Check alpha because completion can run multiple times if interrupted
            if self.alpha == finalAlpha {
                self.delegate?.cardViewWasDismissed(self)
                self.removeFromSuperview()
            }
        }
    }
    
    private func returnToOriginalPosition() {
        UIView.animate(withDuration: 0.4,
                     delay: 0,
                     usingSpringWithDamping: 0.7, // Spring back animation
                     initialSpringVelocity: 0.5,
                     options: .curveEaseOut) {
            self.center = self.initialCenter
            self.transform = self.originalTransform // Return to original scale and rotation
        }
    }
} 


struct CustomCardPreviewViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black // just to make the card stand out

        let cardView = CustomCardView()
        cardView.center = viewController.view.center
        cardView.configure(text1: "Hello", text2: "This is a card", text3: "Swipe me!")
        cardView.isInteractionEnabled = true

        viewController.view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 300),
            cardView.heightAnchor.constraint(equalToConstant: 400)
        ])

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No dynamic updates for now
    }
}

#Preview {
    CustomCardPreviewViewController()
}
