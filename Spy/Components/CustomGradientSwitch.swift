import UIKit

class CustomGradientSwitch: UIView {
    private let firstView = UIView()
    private let indicatorLabel = UILabel()
    private var gradientAnimationBorder: AnimatedGradientView!
    private var currentAnimator: UIViewPropertyAnimator?
    
    private let switchHeight: CGFloat
    private let borderWidth: CGFloat = GeneralConstants.Button.borderWidth
    
    private var innerSize: CGFloat {
        return switchHeight - 2 * borderWidth
    }
    
    private var switchWidth: CGFloat {
        return 90 //switchHeight * 2 + borderWidth * 3
    }
    
    var isOn: Bool = true
    
    private var status: ButtonStatus = .activeBlue {
        didSet {
            updateAppearance(shadowColor: status.shadowColor, gradientColor: status.gradientColor)
        }
    }
    
    init(switchHeight: CGFloat = GeneralConstants.Button.miniHeight, gradientColor: GradientColor = .blue, shadowColor: ShadowColor = .blue) {
        self.switchHeight = switchHeight
        super.init(frame: .zero)
        setupView()
        setupTapGesture()
        updateAppearance(shadowColor: shadowColor, gradientColor: gradientColor)
        
        firstView.transform = CGAffineTransform(translationX: switchWidth - innerSize - borderWidth * 2, y: 0)
        indicatorLabel.text = "I"
    }
    
    required init?(coder: NSCoder) {
        self.switchHeight = GeneralConstants.Button.miniHeight
        super.init(coder: coder)
        setupView()
        setupTapGesture()
        updateAppearance(shadowColor: .blue, gradientColor: .blue)
        
        firstView.transform = CGAffineTransform(translationX: switchWidth - innerSize - borderWidth * 2, y: 0)
        indicatorLabel.text = "I"
    }
    
    private func setupView() {
        firstView.backgroundColor = .spyBlue04
        firstView.layer.cornerRadius = GeneralConstants.Button.innerCornerRadius
        
        gradientAnimationBorder = AnimatedGradientView(width: switchWidth, height: switchHeight, gradient: .blue)
        gradientAnimationBorder.layer.cornerRadius = GeneralConstants.Button.outerCornerRadius
        gradientAnimationBorder.clipsToBounds = true
        
        indicatorLabel.textColor = .white
        indicatorLabel.font = .boldSystemFont(ofSize: switchHeight * 0.4)
        indicatorLabel.textAlignment = .center
        indicatorLabel.text = "I"
        
        addSubview(gradientAnimationBorder)
        addSubview(firstView)
        firstView.addSubview(indicatorLabel)
        
        gradientAnimationBorder.translatesAutoresizingMaskIntoConstraints = false
        firstView.translatesAutoresizingMaskIntoConstraints = false
        indicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradientAnimationBorder.topAnchor.constraint(equalTo: topAnchor),
            gradientAnimationBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientAnimationBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientAnimationBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientAnimationBorder.widthAnchor.constraint(equalToConstant: switchWidth),
            gradientAnimationBorder.heightAnchor.constraint(equalToConstant: switchHeight),
            
            firstView.centerYAnchor.constraint(equalTo: centerYAnchor),
            firstView.widthAnchor.constraint(equalToConstant: innerSize),
            firstView.heightAnchor.constraint(equalToConstant: innerSize),
            firstView.leadingAnchor.constraint(equalTo: gradientAnimationBorder.leadingAnchor, constant: borderWidth),
            
            indicatorLabel.centerXAnchor.constraint(equalTo: firstView.centerXAnchor),
            indicatorLabel.centerYAnchor.constraint(equalTo: firstView.centerYAnchor)
        ])
        
        status = .activeBlue
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        isOn.toggle()
        status = isOn ? .activeBlue : .deactive
        animateSwitch()
    }
    
    private func animateSwitch() {
        currentAnimator?.stopAnimation(true)
        currentAnimator?.finishAnimation(at: .current)
        
        let targetX = isOn ? 
            switchWidth - innerSize - borderWidth * 2 :
            0
            
        UIView.transition(with: indicatorLabel, duration: GeneralConstants.Animation.duration, options: .transitionFlipFromRight
        ) {
            self.indicatorLabel.text = self.isOn ? "I" : "0"
        }
            
        let animator = UIViewPropertyAnimator(duration: GeneralConstants.Animation.duration, curve: .easeInOut) {
            self.firstView.transform = CGAffineTransform(translationX: targetX, y: 0)
            self.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self] _ in
            self?.currentAnimator = nil
        }
        
        currentAnimator = animator
        animator.startAnimation()
    }
    
    func setState(_ state: Bool) {
        guard state != isOn else { return }
        isOn = state
        status = isOn ? .activeBlue : .deactive
        animateSwitch()
    }
    
    func getState() -> Bool {
        return isOn
    }
    
    private func updateAppearance(shadowColor: ShadowColor, gradientColor: GradientColor) {
        UIView.animate(withDuration: GeneralConstants.Animation.duration) {
            self.gradientAnimationBorder.updateGradient(to: gradientColor)
            self.indicatorLabel.textColor = self.isOn ? .white : .spyGray01
        }
    }
} 
