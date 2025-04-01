//
//  CustomGradientCard.swift
//  Spy
//
//  Created by Zeynep Müslim on 1.04.2025.
//

import UIKit
import SwiftUI

class CustomGradientCard: UIView {
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
            updateAppearance(shadowColor: status.shadowColor, gradientColor: status.gradientColor)
        }
    }
    
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
        setupTapGesture()
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
        setupTapGesture()
    }
    
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
    
    func updateAppearance(shadowColor: ShadowColor, gradientColor: GradientColor) {
        UIView.animate(withDuration: GeneralConstants.Animation.duration, animations: {
            self.shadowColor = shadowColor
            self.thirdView.layer.shadowColor = shadowColor.cgColor
            self.gradientAnimationBorder.updateGradient(to: gradientColor)
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
struct CustomGradientCardViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let button = CustomGradientButton()
        viewController.view.backgroundColor = .systemGray
        
        button.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Gerekirse burada güncelleme yapılabilir
    }
}

struct ViewController_Previews5: PreviewProvider {
    static var previews: some View {
        CustomGradientCardViewController()
    }
}
