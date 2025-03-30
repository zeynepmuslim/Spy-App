import UIKit

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

class CustomGradientButton: UIView {
    var gradientColor: GradientColor
    var width: CGFloat
    var height: CGFloat
    var innerCornerRadius: CGFloat
    var outherCornerRadius: CGFloat
    var shadowColor: ShadowColor
    var borderWidth: CGFloat
    var labelText: String {
        didSet {
            titleLabel.text = labelText
            animateLabelChange()
        }
    }
    
    private let firstView = UIView()
    private let thirdView = UIView()
    private let titleLabel = UILabel()
    private var firstViewTopConstraint: NSLayoutConstraint!
    private var firstViewBottomConstraint: NSLayoutConstraint!
    private var firstViewLeadingConstraint: NSLayoutConstraint!
    private var firstViewTrailingConstraint: NSLayoutConstraint!
    private var gradientAnimationBorder: AnimatedGradientView!
    private var currentAnimator: UIViewPropertyAnimator?
    
    var onClick: (() -> Void)?
    
    init(labelText: String = "", gradientColor: GradientColor = .blue, width: CGFloat = 150, height: CGFloat = 50, innerCornerRadius: CGFloat = 8, outherCornerRadius: CGFloat = 10, shadowColor: ShadowColor = .blue, borderWidth: CGFloat = 3) {
        self.gradientColor = gradientColor
        self.width = width
        self.height = height
        self.innerCornerRadius = innerCornerRadius
        self.outherCornerRadius = outherCornerRadius
        self.shadowColor = shadowColor
        self.borderWidth = borderWidth
        self.labelText = labelText
        super.init(frame: .zero)
        setupView()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        self.gradientColor = .blue
        self.width = 150
        self.height = 50
        self.innerCornerRadius = 8
        self.outherCornerRadius = 10
        self.shadowColor = .red
        self.borderWidth = 5
        self.labelText = "Button"
        super.init(coder: coder)
        setupView()
        setupTapGesture()
    }
    
    private func setupView() {
        firstView.backgroundColor = .spyBlue04
        firstView.layer.cornerRadius = innerCornerRadius
        
        gradientAnimationBorder = AnimatedGradientView(width: width, height: height, gradient: gradientColor)
        gradientAnimationBorder.layer.cornerRadius = outherCornerRadius
        gradientAnimationBorder.clipsToBounds = true
        
        thirdView.backgroundColor = .gray
        thirdView.layer.shadowColor = shadowColor.cgColor
        thirdView.layer.shadowOpacity = 1.0
        thirdView.layer.shadowOffset = CGSize(width: 0, height: 1)
        thirdView.layer.shadowRadius = outherCornerRadius
        thirdView.layer.cornerRadius = outherCornerRadius
        
        titleLabel.text = labelText
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
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
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        print("handleTap by GradientButton")
        
        currentAnimator?.stopAnimation(true)
        currentAnimator?.finishAnimation(at: .current)
    
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            AnimationHelper.animateButton(
                firstView: self.firstView,
                thirdView: self.thirdView,
                firstViewTopConstraint: self.firstViewTopConstraint,
                firstViewBottomConstraint: self.firstViewBottomConstraint,
                firstViewLeadingConstraint: self.firstViewLeadingConstraint,
                firstViewTrailingConstraint: self.firstViewTrailingConstraint,
                outerCornerRadius: self.outherCornerRadius,
                innerCornerRadius: self.innerCornerRadius,
                borderWidth: self.borderWidth
            )
            self.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self] _ in
            self?.currentAnimator = nil
        }
        
        currentAnimator = animator
        animator.startAnimation()
        onClick?()
    }
    
    private func animateLabelChange() {
        UIView.transition(with: titleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.titleLabel.text = self.labelText
        }, completion: nil)
    }
    
    func updateAppearance(shadowColor: ShadowColor, gradientColor: GradientColor) {
        UIView.animate(withDuration: 0.3, animations: {
            self.shadowColor = shadowColor
            self.thirdView.layer.shadowColor = shadowColor.cgColor
            self.gradientAnimationBorder.updateGradient(to: gradientColor)
        })
    }
}
