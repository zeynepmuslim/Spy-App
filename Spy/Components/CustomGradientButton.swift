import UIKit
import SwiftUI

class CustomGradientButton: UIView {
    var gradientColor: GradientColor
    var buttonColor: ButtonColor
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
    
    private var status: ButtonStatus = .activeBlue {
        didSet {
            updateAppearance(shadowColor: status.shadowColor, gradientColor: status.gradientColor, buttonColor: status.buttonColor)
        }
    }
    
    init(labelText: String = "Hiii", gradientColor: GradientColor = .blue, width: CGFloat = GeneralConstants.Button.defaultWidth, height: CGFloat = GeneralConstants.Button.defaultHeight, innerCornerRadius: CGFloat = GeneralConstants.Button.innerCornerRadius, outherCornerRadius: CGFloat = GeneralConstants.Button.outerCornerRadius, shadowColor: ShadowColor = .blue, buttonColor: ButtonColor = .blue,borderWidth: CGFloat = GeneralConstants.Button.borderWidth, fontSize: CGFloat = GeneralConstants.Font.size04, isBorderlessButton: Bool = false) {
        self.gradientColor = gradientColor
        self.width = width
        self.height = height
        self.innerCornerRadius = innerCornerRadius
        self.outherCornerRadius = outherCornerRadius
        self.shadowColor = shadowColor
        self.borderWidth = borderWidth
        self.labelText = labelText
        self.isBorderlessButton = isBorderlessButton
        self.buttonColor = buttonColor
        super.init(frame: .zero)
        setupView(fontSize: fontSize)
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        self.gradientColor = .blue
        self.width = GeneralConstants.Button.defaultWidth
        self.height = GeneralConstants.Button.defaultHeight
        self.innerCornerRadius = GeneralConstants.Button.innerCornerRadius
        self.outherCornerRadius = GeneralConstants.Button.outerCornerRadius
        self.shadowColor = .blue
        self.borderWidth = GeneralConstants.Button.borderWidth
        self.labelText = "Button"
        self.isBorderlessButton = false
        self.buttonColor = ButtonColor.blue
        super.init(coder: coder)
        setupView(fontSize: GeneralConstants.Font.size04)
        setupTapGesture()
    }
    
    private func setupView(fontSize: CGFloat) {
        firstView.backgroundColor = buttonColor.color
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
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        currentAnimator?.stopAnimation(true)
        currentAnimator?.finishAnimation(at: .current)
    
        let animator = UIViewPropertyAnimator(duration: GeneralConstants.Animation.duration, curve: .easeInOut) {
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
        UIView.transition(with: titleLabel, duration: GeneralConstants.Animation.duration, options: .transitionCrossDissolve, animations: {
            self.titleLabel.text = self.labelText
        }, completion: nil)
    }
    
    func updateAppearance(shadowColor: ShadowColor, gradientColor: GradientColor, buttonColor: ButtonColor) {
        UIView.animate(withDuration: GeneralConstants.Animation.duration, animations: {
            self.shadowColor = shadowColor
            self.thirdView.layer.shadowColor = shadowColor.cgColor
            self.gradientAnimationBorder.updateGradient(to: gradientColor)
            self.firstView.backgroundColor = buttonColor.color
        })
    }
    
    func setStatus(_ newStatus: ButtonStatus) {
        status = newStatus
    }
    
    func getStatus() -> ButtonStatus {
        return status
    }
}

//Preview
struct CustomGradientButtonViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemGray
        
        let button1 = CustomGradientButton(
            labelText: "Başla",
            gradientColor: .red,
            width: 250,
            height: 60,
            innerCornerRadius: 8,
            outherCornerRadius: 10,
            shadowColor: .red,
            isBorderlessButton: false
        )
        button1.setStatus(.activeRed)

        let button2 = CustomGradientButton(
            labelText: "Devam Et",
            gradientColor: .blue,
            width: 200,
            height: 50,
            innerCornerRadius: 8,
            outherCornerRadius: 16,
            shadowColor: .blue,
            isBorderlessButton: false
        )
        button2.setStatus(.activeBlue)

        let button3 = CustomGradientButton(
            labelText: "Devre Dışı",
            gradientColor: .gray,
            width: 180,
            height: 45,
            innerCornerRadius: 8,
            outherCornerRadius: 12,
            shadowColor: .gray,
            isBorderlessButton: false
        )
        button3.setStatus(.deactive)

        let button4 = CustomGradientButton(
            labelText: "Sadece Kenarlık",
            gradientColor: .blue,
            width: 220,
            height: 50,
            innerCornerRadius: 10,
            outherCornerRadius: 20,
            shadowColor: .blue,
            isBorderlessButton: true
        )

        let button5 = CustomGradientButton(
            labelText: "Uzun Yazı Butonu",
            gradientColor: .red,
            width: 300,
            height: 55,
            innerCornerRadius: 14,
            outherCornerRadius: 22,
            shadowColor: .red,
            isBorderlessButton: false
        )
        button5.setStatus(.activeRed)

        let stackView = UIStackView(arrangedSubviews: [button1, button2, button3, button4, button5])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        viewController.view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ViewController_Previews4: PreviewProvider {
    static var previews: some View {
        CustomGradientButtonViewController()
    }
}
