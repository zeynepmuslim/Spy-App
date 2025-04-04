import UIKit
import SwiftUI

class PlayerSettingsGroupManager {
     enum Constants {
        static let iconSpacing: CGFloat = 10
        static let animationDuration: TimeInterval = 0.4
        static let fadeInDuration: TimeInterval = 0.15
        static let titleSize: CGFloat = 18
        static let maxIconSize: CGFloat = 45
        static let iconThreshold: Int = 6
        static let waveDelay: TimeInterval = 0.05
    }
    
    class PlayerGroup {
        let stackView: UIStackView
        let horizontalStackView: UIStackView
        var imageViews: [UIImageView]
        let label: VerticalAlignedLabel
        let minusButton: CustomGradientButton
        let plusButton: CustomGradientButton
        let spacerView: UIView
        let imagesStackView: UIStackView
        let minSpyCount: Int
        let maxSpyCount: Int
        let buttonBorderColor: GradientColor
        
        private var isAnimating: Bool = false // buttonların hızına animayonlar yeşimediğinden bug ı engellemek için butonları disable yap
        private var spacerWidthConstraint: NSLayoutConstraint?
        
        init(title: String, 
             target: UIViewController, 
             index: Int,
             buttonBorderColor: GradientColor = .blue,
             buttonShadow: ShadowColor = .blue,
             buttonColor: ButtonColor = .blue,
             minSpyCount: Int = 1,
             maxSpyCount: Int = 8) {
            
            self.minSpyCount = max(1, minSpyCount)
            self.maxSpyCount = max(self.minSpyCount, maxSpyCount)
            
            self.buttonBorderColor = buttonBorderColor
            
            stackView = UIStackView()
            horizontalStackView = UIStackView()
            imagesStackView = UIStackView()
            spacerView = UIView()
            imageViews = []
            
            stackView.axis = .vertical
            stackView.spacing = Constants.iconSpacing
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = Constants.iconSpacing
            horizontalStackView.alignment = .center
            horizontalStackView.distribution = .fill
            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            
            imagesStackView.axis = .horizontal
            imagesStackView.spacing = Constants.iconSpacing
            imagesStackView.alignment = .center
            imagesStackView.distribution = .fillEqually
            imagesStackView.translatesAutoresizingMaskIntoConstraints = false
            
            spacerView.translatesAutoresizingMaskIntoConstraints = false
            spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            label = VerticalAlignedLabel()
            label.text = title
            label.textColor = .white
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFont(ofSize: Constants.titleSize)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.verticalAlignment = .custom(5)
            
            minusButton = CustomGradientButton(labelText: "-", gradientColor: buttonBorderColor, width: GeneralConstants.Button.miniHeight, height: GeneralConstants.Button.miniHeight, shadowColor: buttonShadow, buttonColor: buttonColor)
            minusButton.translatesAutoresizingMaskIntoConstraints = false
            
            plusButton = CustomGradientButton(labelText: "+", gradientColor: buttonBorderColor, width: GeneralConstants.Button.miniHeight, height: GeneralConstants.Button.miniHeight, shadowColor: buttonShadow, buttonColor: buttonColor)
            plusButton.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(horizontalStackView)
            
            createSpyImages()
            
            horizontalStackView.addArrangedSubview(imagesStackView)
            horizontalStackView.addArrangedSubview(spacerView)
            horizontalStackView.addArrangedSubview(minusButton)
            horizontalStackView.addArrangedSubview(plusButton)
            
            imagesStackView.widthAnchor.constraint(equalTo: label.widthAnchor).isActive = true
            horizontalStackView.widthAnchor.constraint(equalTo: label.widthAnchor).isActive = true
            
            // Create the width constraint but keep it inactive initially
            spacerWidthConstraint = spacerView.widthAnchor.constraint(equalToConstant: 5)
            spacerWidthConstraint?.priority = .defaultHigh // Give it priority over hugging/compression
            
            minusButton.onClick = { [weak self] in
                self?.removeSpyImage()
            }
            
            plusButton.onClick = { [weak self] in
                self?.addSpyImage()
            }
            
            updateButtonStates()
            updateSpacerState(animated: false)
        }
        
        private func createSpyImages() {
            for _ in 0..<minSpyCount {
                addSpyImage(animated: false)
            }
        }
        
        private func createSpyImageView() -> UIImageView {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.maxIconSize).isActive = true
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.maxIconSize).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            
            return imageView
        }
        
        private func updateImageIcon(_ imageView: UIImageView, shouldUseCircle: Bool) {
            imageView.image = shouldUseCircle ? 
                UIImage(systemName: "circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal) :
                UIImage(named: "spy-w")
        }
        
        private func updateAllImages(completion: (() -> Void)? = nil) {
            let shouldUseCircle = imageViews.count > Constants.iconThreshold
            let totalDuration = Double(imageViews.count) * Constants.waveDelay + Constants.animationDuration
            
            for (index, imageView) in imageViews.enumerated() {
                let delay = Double(index) * Constants.waveDelay
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    UIView.transition(with: imageView,
                                    duration: Constants.animationDuration,
                                    options: .transitionCrossDissolve,
                                    animations: {
                        self.updateImageIcon(imageView, shouldUseCircle: shouldUseCircle)
                    })
                }
            }
            
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                    completion()
                }
            }
        }
        
        private func addSpyImage(animated: Bool = true) {
            guard imageViews.count < maxSpyCount else { return }
            
            let willCrossThreshold = imageViews.count + 1 > Constants.iconThreshold
            let isAlreadyPastThreshold = imageViews.count > Constants.iconThreshold
            
            if animated {
                let imageView = createSpyImageView()
                updateImageIcon(imageView, shouldUseCircle: isAlreadyPastThreshold)
                
                imageView.alpha = 0
                imageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                
                imagesStackView.addArrangedSubview(imageView)
                imageViews.append(imageView)
                
                UIView.animate(withDuration: Constants.animationDuration * 0.6,
                             delay: 0,
                             usingSpringWithDamping: 0.55,
                             initialSpringVelocity: 0.3,
                             options: .curveEaseOut,
                             animations: {
                    imageView.alpha = 1
                    imageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                }) { _ in
                    UIView.animate(withDuration: Constants.animationDuration * 0.4,
                                 delay: 0,
                                 usingSpringWithDamping: 0.7,
                                 initialSpringVelocity: 0.2,
                                 options: .curveEaseOut,
                                 animations: {
                        imageView.transform = .identity
                    }) { [weak self] _ in
                        if willCrossThreshold && !isAlreadyPastThreshold {
                            self?.updateAllImages()
                        }
                        self?.isAnimating = false
                        self?.updateButtonStates()
                        self?.updateSpacerState(animated: true)
                    }
                }
            } else {
                let imageView = createSpyImageView()
                updateImageIcon(imageView, shouldUseCircle: isAlreadyPastThreshold)
                imagesStackView.addArrangedSubview(imageView)
                imageViews.append(imageView)
                
                if willCrossThreshold && !isAlreadyPastThreshold {
                    updateAllImages()
                }
                isAnimating = false
                updateButtonStates()
                updateSpacerState(animated: false)
            }
        }
        
        private func removeSpyImage(animated: Bool = true) {
            guard imageViews.count > minSpyCount else { return }
            guard let lastImageView = imageViews.last else { return }
            guard !isAnimating else { return }
            
            let willCrossThreshold = imageViews.count == Constants.iconThreshold + 1
            
            if animated {
                isAnimating = true
                updateButtonStates()
                
                UIView.animate(withDuration: Constants.animationDuration * 0.5,
                             delay: 0,
                             usingSpringWithDamping: 0.6,
                             initialSpringVelocity: 0.3,
                             options: .curveEaseOut,
                             animations: {
                    lastImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                }) { _ in
                    UIView.animate(withDuration: Constants.animationDuration * 0.5,
                                 delay: 0,
                                 options: [.curveEaseIn],
                                 animations: {
                        lastImageView.alpha = 0
                        lastImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    }) { [weak self] _ in
                        lastImageView.removeFromSuperview()
                        self?.imageViews.removeLast()
                        
                        if willCrossThreshold {
                            self?.updateAllImages()
                        }
                        self?.isAnimating = false
                        self?.updateButtonStates()
                        self?.updateSpacerState(animated: true)
                    }
                }
            } else {
                lastImageView.removeFromSuperview()
                imageViews.removeLast()
                if willCrossThreshold {
                    updateAllImages()
                }
                isAnimating = false
                updateButtonStates()
                updateSpacerState(animated: false)
            }
        }
        
        private func updateButtonStates() {
            let currentCount = imageViews.count
            
            let minusEnabledByCount = currentCount > minSpyCount
            let plusEnabledByCount = currentCount < maxSpyCount
            
            updateButtonVisuals(minusButton, isEnabled: minusEnabledByCount)
            updateButtonVisuals(plusButton, isEnabled: plusEnabledByCount)
            
            minusButton.isUserInteractionEnabled = minusEnabledByCount && !isAnimating
            plusButton.isUserInteractionEnabled = plusEnabledByCount && !isAnimating
        }
        
        // Renamed function to clarify its purpose
        private func updateButtonVisuals(_ button: CustomGradientButton, isEnabled: Bool) {
            if isEnabled {
                button.setStatus(buttonBorderColor == .red ? .activeRed : .activeBlue)
            } else {
                button.setStatus(.deactive)
            }
        }
        
        private func updateSpacerState(animated: Bool) {
            let shouldHaveSmallWidth = imageViews.count > Constants.iconThreshold - 1
            let isCurrentlySmall = spacerWidthConstraint?.isActive ?? false
            
            guard isCurrentlySmall != shouldHaveSmallWidth else { return } // No change needed

            let updateLayout = { [weak self] in
                if shouldHaveSmallWidth {
                    self?.spacerWidthConstraint?.isActive = true
                } else {
                    self?.spacerWidthConstraint?.isActive = false
                }
                // Crucial for animating constraint changes
                self?.horizontalStackView.layoutIfNeeded()
            }

            if animated {
                UIView.animate(withDuration: Constants.animationDuration * 0.5, delay: 0, options: .curveEaseInOut) {
                    updateLayout()
                }
            } else {
                updateLayout()
            }
        }
    }
}
