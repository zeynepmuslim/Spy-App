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
    private let firstView = UIView()
    private let thirdView = UIView()
    private var firstViewTopConstraint: NSLayoutConstraint!
    private var firstViewBottomConstraint: NSLayoutConstraint!
    private var firstViewLeadingConstraint: NSLayoutConstraint!
    private var firstViewTrailingConstraint: NSLayoutConstraint!
    private var gradientAnimationBorder: AnimatedGradientView!
    private var currentAnimator: UIViewPropertyAnimator?
    
    private let maxRotation: CGFloat = .pi / 10
    private let throwVelocityThreshold: CGFloat = 1000
    private let dismissalThreshold: CGFloat = 0.4
    
    private var status: ButtonStatus = .deactive {
        didSet {
            updateAppearance(shadowColor: status.shadowColor, gradientColor: status.gradientColor)
        }
    }
    
    private let label1: UILabel = {
        let label = UILabel()
        label.text = "Label 1"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.text = "Label 2"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let label3: UILabel = {
        let label = UILabel()
        label.text = "Label 3"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let spyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        imageView.image = UIImage(named: "spy-w")
        return imageView
    }()
    
    private var frontText1: String = ""
    private var frontText2: String = ""
    private var frontText3: String = ""
    private var backText1: String = ""
    private var backText2: String = ""
    private var backText3: String = ""
    
    private var hasBeenFlipped = false
    var isFlipEnabled: Bool = true
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isSpy: Bool = false
    
    init(labelText: String = "Hiii", gradientColor: GradientColor = .gray, width: CGFloat = GeneralConstants.Button.defaultWidth, height: CGFloat = GeneralConstants.Button.defaultHeight, innerCornerRadius: CGFloat = GeneralConstants.Button.innerCornerRadius, outherCornerRadius: CGFloat = GeneralConstants.Button.outerCornerRadius, shadowColor: ShadowColor = .gray, borderWidth: CGFloat = GeneralConstants.Button.borderWidth, fontSize: CGFloat = GeneralConstants.Font.size04, isBorderlessButton: Bool = false) {
        self.gradientColor = gradientColor
        self.width = width
        self.height = height
        self.innerCornerRadius = innerCornerRadius
        self.outherCornerRadius = outherCornerRadius
        self.shadowColor = shadowColor
        self.borderWidth = borderWidth
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
        super.init(coder: coder)
        setupView(fontSize: GeneralConstants.Font.size04)
        setupLabels()
        setupGestures()
        isUserInteractionEnabled = false
    }
    private func setupView(fontSize: CGFloat) {
        firstView.backgroundColor = .spyBlue04
        firstView.layer.cornerRadius = innerCornerRadius
        firstView.translatesAutoresizingMaskIntoConstraints = false
        
        gradientAnimationBorder = AnimatedGradientView(width: width, height: height, gradient: gradientColor)
        gradientAnimationBorder.layer.cornerRadius = outherCornerRadius
        gradientAnimationBorder.clipsToBounds = true
        gradientAnimationBorder.translatesAutoresizingMaskIntoConstraints = false
        
        thirdView.backgroundColor = .gray
        thirdView.layer.shadowColor = shadowColor.cgColor
        thirdView.layer.shadowOpacity = GeneralConstants.Button.shadowOpacity
        thirdView.layer.shadowOffset = CGSize(width: 0, height: 1)
        thirdView.layer.shadowRadius = outherCornerRadius
        thirdView.layer.cornerRadius = outherCornerRadius
        thirdView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(thirdView)
        containerView.addSubview(gradientAnimationBorder)
        containerView.addSubview(firstView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        firstViewTopConstraint = firstView.topAnchor.constraint(equalTo: gradientAnimationBorder.topAnchor, constant: borderWidth)
        firstViewBottomConstraint = firstView.bottomAnchor.constraint(equalTo: gradientAnimationBorder.bottomAnchor, constant: -borderWidth)
        firstViewLeadingConstraint = firstView.leadingAnchor.constraint(equalTo: gradientAnimationBorder.leadingAnchor, constant: borderWidth)
        firstViewTrailingConstraint = firstView.trailingAnchor.constraint(equalTo: gradientAnimationBorder.trailingAnchor, constant: -borderWidth)
        
        NSLayoutConstraint.activate([
            gradientAnimationBorder.topAnchor.constraint(equalTo: containerView.topAnchor),
            gradientAnimationBorder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            gradientAnimationBorder.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            gradientAnimationBorder.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            firstViewTopConstraint,
            firstViewLeadingConstraint,
            firstViewTrailingConstraint,
            firstViewBottomConstraint,
            
            thirdView.topAnchor.constraint(equalTo: gradientAnimationBorder.topAnchor),
            thirdView.leadingAnchor.constraint(equalTo: gradientAnimationBorder.leadingAnchor),
            thirdView.trailingAnchor.constraint(equalTo: gradientAnimationBorder.trailingAnchor),
            thirdView.bottomAnchor.constraint(equalTo: gradientAnimationBorder.bottomAnchor)
        ])
    }
    
    private func setupLabels() {
        containerView.addSubview(label1)
        containerView.addSubview(label2)
        containerView.addSubview(label3)
        containerView.addSubview(spyImageView)

        let topGuide = UILayoutGuide()
        let middleGuide = UILayoutGuide()
        let bottomGuide = UILayoutGuide()

        containerView.addLayoutGuide(topGuide)
        containerView.addLayoutGuide(middleGuide)
        containerView.addLayoutGuide(bottomGuide)

        let horizontalPadding: CGFloat = 20

        NSLayoutConstraint.activate([
            topGuide.topAnchor.constraint(equalTo: containerView.topAnchor),
            topGuide.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topGuide.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            topGuide.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1.0/3.0),

            middleGuide.topAnchor.constraint(equalTo: topGuide.bottomAnchor),
            middleGuide.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            middleGuide.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            middleGuide.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1.0/3.0),

            bottomGuide.topAnchor.constraint(equalTo: middleGuide.bottomAnchor),
            bottomGuide.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomGuide.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomGuide.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            label1.centerXAnchor.constraint(equalTo: topGuide.centerXAnchor),
            label1.centerYAnchor.constraint(equalTo: topGuide.centerYAnchor),
            label1.leadingAnchor.constraint(greaterThanOrEqualTo: topGuide.leadingAnchor, constant: horizontalPadding),
            label1.trailingAnchor.constraint(lessThanOrEqualTo: topGuide.trailingAnchor, constant: -horizontalPadding),

            label2.centerXAnchor.constraint(equalTo: middleGuide.centerXAnchor),
            label2.centerYAnchor.constraint(equalTo: middleGuide.centerYAnchor),
            label2.leadingAnchor.constraint(greaterThanOrEqualTo: middleGuide.leadingAnchor, constant: horizontalPadding),
            label2.trailingAnchor.constraint(lessThanOrEqualTo: middleGuide.trailingAnchor, constant: -horizontalPadding),

            spyImageView.centerXAnchor.constraint(equalTo: middleGuide.centerXAnchor),
            spyImageView.centerYAnchor.constraint(equalTo: middleGuide.centerYAnchor),
            spyImageView.widthAnchor.constraint(equalTo: middleGuide.widthAnchor, multiplier: 0.5),
            spyImageView.heightAnchor.constraint(equalTo: spyImageView.widthAnchor),

            label3.centerXAnchor.constraint(equalTo: bottomGuide.centerXAnchor),
            label3.topAnchor.constraint(equalTo: bottomGuide.topAnchor),
            label3.leadingAnchor.constraint(greaterThanOrEqualTo: bottomGuide.leadingAnchor, constant: horizontalPadding),
            label3.trailingAnchor.constraint(lessThanOrEqualTo: bottomGuide.trailingAnchor, constant: -horizontalPadding)
        ])
    }
    
    func setStatus(_ newStatus: ButtonStatus) {
        status = newStatus
    }
    
    func getStatus() -> ButtonStatus {
        return status
    }
    
    func updateAppearance(shadowColor: ShadowColor, gradientColor: GradientColor) {
        UIView.animate(withDuration: GeneralConstants.Animation.duration, animations: {
            self.shadowColor = shadowColor
            self.thirdView.layer.shadowColor = shadowColor.cgColor
            self.gradientAnimationBorder.updateGradient(to: gradientColor)
            self.firstView.backgroundColor = self.status.buttonColor.color
        })
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    func configure(role: String, selectedWord: String, label: String, isSpy: Bool = false) {
        hasBeenFlipped = false
        label1.transform = .identity
        label2.transform = .identity
        label3.transform = .identity
        
        frontText1 = role
        frontText2 = selectedWord
        frontText3 = label
        
        backText1 = isSpy ? "SPY" : "CIVILIAN"
        backText2 = isSpy ? "You are a Spy!" : "You are a Civilian!"
        backText3 = isSpy ? "Try to blend in!" : "Find the Spies!"
        
        label1.text = frontText1
        label2.text = frontText2
        label3.text = frontText3
        
        self.isSpy = isSpy
    }

    @objc private func handleTap() {
        if !hasBeenFlipped && isFlipEnabled {
            guard isInteractionEnabled else { return }
            
            let status: ButtonStatus = isSpy ? .activeRed : .activeBlue
            
            let originalZPosition = layer.zPosition // z poziyonu ayar gerkli çünkü flip 3D olarak oynuyır eğer oluştuştuğu layerde kalırsa kartlar iç içe geliyor
            layer.zPosition = 1000
            
            var transform3D = CATransform3DIdentity
            transform3D.m34 = -1.0 / 500.0
            
            isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.3,
                         delay: 0,
                         options: .curveEaseIn) {
                transform3D = CATransform3DRotate(transform3D, .pi / 2, 0.0, 1.0, 0.0)
                self.layer.transform = transform3D
                
                self.label1.alpha = 0
                self.label2.alpha = 0
                self.label3.alpha = 0
                self.spyImageView.alpha = 0
            } completion: { _ in
                self.setStatus(status)
                self.label1.text = self.backText1
                self.label3.text = self.backText3
                
                self.label1.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.label2.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.label3.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.spyImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
                
                UIView.animate(withDuration: 0.3) {
                    self.label1.alpha = 1
                    self.label3.alpha = 1
                    if self.isSpy {
                        self.spyImageView.alpha = 1
                    } else {
                        self.label2.text = self.backText2
                        self.label2.alpha = 1
                    }
                }
                
                UIView.animate(withDuration: 0.3,
                             delay: 0,
                             options: .curveEaseOut) {
                    transform3D = CATransform3DRotate(transform3D, .pi / 2, 0.0, 1.0, 0.0)
                    self.layer.transform = transform3D
                } completion: { _ in
                    self.layer.zPosition = originalZPosition
                    self.isUserInteractionEnabled = true
                    self.hasBeenFlipped = true
                }
            }
        } else {
            let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            bounceAnimation.values = [1.0, 0.99, 1.02, 0.99, 1.0]
            bounceAnimation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8]
            bounceAnimation.duration = 0.8
            bounceAnimation.timingFunctions = [
                CAMediaTimingFunction(name: .easeInEaseOut),
                CAMediaTimingFunction(name: .easeInEaseOut),
                CAMediaTimingFunction(name: .easeInEaseOut),
                CAMediaTimingFunction(name: .easeInEaseOut)
            ]
            self.layer.add(bounceAnimation, forKey: "bounce")
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        switch gesture.state {
        case .began:
            initialCenter = center
            
        case .changed:
            let resistance: CGFloat = 0.8
            center = CGPoint(x: initialCenter.x + (translation.x * resistance),
                           y: initialCenter.y + (translation.y * resistance))
            
            let rotationAngle = (translation.x / bounds.width) * maxRotation * resistance
            containerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
        case .ended:
            if hasBeenFlipped || !isFlipEnabled {
                let horizontalVelocityHigh = abs(velocity.x) > throwVelocityThreshold
                let horizontalMovedFar = abs(translation.x) > bounds.width * dismissalThreshold
                let shouldDismissHorizontally = horizontalVelocityHigh || horizontalMovedFar
                
                let verticalVelocityHigh = abs(velocity.y) > throwVelocityThreshold
                let verticalMovedFar = abs(translation.y) > bounds.height * dismissalThreshold
                let shouldDismissVertically = verticalVelocityHigh || verticalMovedFar
                
                if shouldDismissHorizontally || shouldDismissVertically {
                    dismissCard(velocity: velocity, translation: translation)
                    return
                }
            }
            
            let velocityFactor = CGPoint(
                x: abs(velocity.x) / 1000.0,
                y: abs(velocity.y) / 1000.0
            )
            
            UIView.animate(withDuration: 0.5,
                         delay: 0,
                         usingSpringWithDamping: 0.5,
                         initialSpringVelocity: max(velocityFactor.x, velocityFactor.y),
                         options: [.curveEaseOut, .allowUserInteraction]) {
                self.center = self.initialCenter
                self.containerView.transform = .identity
            }
            
        default:
            UIView.animate(withDuration: 0.5,
                         delay: 0,
                         usingSpringWithDamping: 0.5,
                         initialSpringVelocity: 0.5,
                         options: [.curveEaseOut, .allowUserInteraction]) {
                self.center = self.initialCenter
                self.containerView.transform = .identity
            }
        }
    }
    private func dismissCard(velocity: CGPoint, translation: CGPoint) {
        let screenBounds = UIScreen.main.bounds
        let isVerticalDismissal = abs(translation.y) > abs(translation.x)
        
        var finalCenter = center
        var finalRotation: CGFloat = 0
        
        if isVerticalDismissal {
            let directionY: CGFloat = velocity.y >= 0 ? 1 : -1
            finalCenter.y += screenBounds.height * directionY
        } else {
            let directionX: CGFloat = velocity.x >= 0 ? 1 : -1
            finalCenter.x += screenBounds.width * directionX
            finalRotation = directionX * .pi / 4
        }
        
        UIView.animate(withDuration: 0.3,
                     delay: 0,
                     options: .curveEaseOut) {
            self.center = finalCenter
            self.containerView.transform = CGAffineTransform(rotationAngle: finalRotation)
            self.alpha = 1
        } completion: { _ in
            self.delegate?.cardViewWasDismissed(self)
            self.removeFromSuperview()
        }
    }
} 

// MARK: - Preview Provider
struct CustomCardPreviewViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black

        let cardView = CustomCardView()
        cardView.center = viewController.view.center
        cardView.configure(role: "Hello", selectedWord: "This is a card", label: "Swipe me!")
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
