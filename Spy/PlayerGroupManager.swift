import UIKit
import SwiftUI

/// Manages the player groups and their associated UI elements in the game settings
class PlayerGroupManager {
    /// Constants used throughout the PlayerGroupManager
    private enum Constants {
        static let iconSpacing: CGFloat = 8        // Space between icons in the stack view
        static let buttonsHeight: CGFloat = 40     // Height of the plus/minus buttons
        static let initialIconSize: CGFloat = 50   // Initial size of player icons
        static let maxPlayerCount: Int = 6         // Maximum number of players before switching to circle icons
        static let animationDuration: TimeInterval = 0.3  // Duration for main animations
        static let fadeInDuration: TimeInterval = 0.15    // Duration for fade-in effects
    }
    
    /// Represents a group of players with their associated UI elements
    class PlayerGroup {
        let stackView: UIStackView           // Contains the player icons
        var imageViews: [UIImageView]        // Collection of player icons
        let label: UILabel                   // Title label for the group
        let minusButton: CustomGradientButton // Button to remove players
        let plusButton: CustomGradientButton  // Button to add players
        private let spacerView: UIView       // Spacer for alignment purposes
        
        /// Initializes a new player group with the specified configuration
        /// - Parameters:
        ///   - title: The title of the group
        ///   - target: The view controller that owns this group
        ///   - index: The index of this group in the collection
        ///   - onRemove: Callback for player removal
        ///   - onAdd: Callback for player addition
        init(title: String, target: UIViewController, index: Int, onRemove: @escaping () -> Void, onAdd: @escaping () -> Void) {
            stackView = {
                let stack = UIStackView()
                stack.axis = .horizontal
                stack.spacing = Constants.iconSpacing
                stack.alignment = .leading
                stack.distribution = .fill
                stack.translatesAutoresizingMaskIntoConstraints = false
                return stack
            }()
            
            spacerView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.setContentHuggingPriority(.defaultLow, for: .horizontal)
                view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                return view
            }()
            
            imageViews = []
            
            label = {
                let label = UILabel()
                label.text = title
                label.textColor = .white
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            minusButton = {
                let button = CustomGradientButton(labelText: "-", width: Constants.buttonsHeight, height: Constants.buttonsHeight)
                button.onClick = onRemove
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            plusButton = {
                let button = CustomGradientButton(labelText: "+", width: Constants.buttonsHeight, height: Constants.buttonsHeight)
                button.onClick = onAdd
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            // Add views to stack view in correct order for left alignment
            stackView.addArrangedSubview(spacerView)
            
            // Set stack view to full width
            stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            stackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
    }
    
    // MARK: - Icon Management
    
    /// Removes the last icon from the specified player group
    /// - Parameters:
    ///   - group: The player group to remove from
    ///   - animated: Whether to animate the removal
    func removeLastIcon(from group: PlayerGroup, animated: Bool) {
        guard let lastImageView = group.imageViews.popLast() else { return }
        
        if animated {
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                lastImageView.alpha = 0
                lastImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) { [weak self] _ in
                lastImageView.removeFromSuperview()
                self?.adjustIconSizes(for: group, animated: true)
            }
        } else {
            lastImageView.removeFromSuperview()
            adjustIconSizes(for: group, animated: false)
        }
    }
    
    /// Adds a new icon to the specified player group
    /// - Parameter group: The player group to add to
    func addNewIcon(to group: PlayerGroup) {
        let newImageView = createIconImageView()
        configureNewIcon(newImageView, for: group)
        animateNewIcon(newImageView)
    }
    
    // MARK: - Private Helper Methods
    
    /// Creates a new image view configured for player icons
    private func createIconImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "spy-w"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.frame.size = CGSize(width: 5, height: 5)
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    /// Configures a new icon with proper constraints and animation setup
    /// - Parameters:
    ///   - imageView: The image view to configure
    ///   - group: The group the icon belongs to
    private func configureNewIcon(_ imageView: UIImageView, for group: PlayerGroup) {
        let count = CGFloat(group.imageViews.count + 1)
        let newSize = min(Constants.initialIconSize * (3.0 / count), Constants.initialIconSize)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: newSize),
            imageView.heightAnchor.constraint(equalToConstant: newSize)
        ])
        
        let containerWidth = group.stackView.bounds.width
        let yOffset = group.imageViews.first?.frame.minY ?? group.stackView.bounds.height / 2
        imageView.transform = CGAffineTransform(translationX: containerWidth / 10, y: yOffset)
        
        group.imageViews.append(imageView)
        
        // Insert new icon before the spacer view for left alignment
        let insertIndex = group.stackView.arrangedSubviews.count - 1 // Insert before spacer view
        group.stackView.insertArrangedSubview(imageView, at: insertIndex)
        
        adjustIconSizes(for: group, animated: true)
    }
    
    /// Animates a new icon's appearance with fade and transform effects
    /// - Parameter imageView: The image view to animate
    private func animateNewIcon(_ imageView: UIImageView) {
        UIView.animate(withDuration: Constants.animationDuration,
                      delay: 0,
                      options: .curveEaseOut,
                      animations: {
            imageView.transform = .identity
        }) { _ in
            UIView.animate(withDuration: Constants.fadeInDuration,
                         delay: 0,
                         options: .curveLinear,
                         animations: {
                imageView.alpha = 1
            })
        }
    }
    
    /// Adjusts the size of all icons in a group based on the total count
    /// - Parameters:
    ///   - group: The group whose icons need adjustment
    ///   - animated: Whether to animate the size changes
    private func adjustIconSizes(for group: PlayerGroup, animated: Bool) {
        let count = CGFloat(group.imageViews.count)
        let newSize = min(Constants.initialIconSize * (4.0 / count), Constants.initialIconSize)
        
        let animationBlock = { [weak self] in
            guard let self = self else { return }
            group.imageViews.forEach { imageView in
                self.updateIconConstraints(imageView, size: newSize)
                self.updateIconAppearance(imageView, size: newSize, count: group.imageViews.count)
            }
            group.stackView.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: Constants.animationDuration,
                         delay: 0,
                         options: .curveEaseOut,
                         animations: animationBlock)
        } else {
            animationBlock()
        }
    }
    
    /// Updates the constraints for an individual icon
    /// - Parameters:
    ///   - imageView: The image view to update
    ///   - size: The new size for the icon
    private func updateIconConstraints(_ imageView: UIImageView, size: CGFloat) {
        NSLayoutConstraint.deactivate(imageView.constraints)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: size),
            imageView.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    /// Updates the appearance of an icon based on the total count
    /// - Parameters:
    ///   - imageView: The image view to update
    ///   - size: The base size for the icon
    ///   - count: The total number of icons in the group
    private func updateIconAppearance(_ imageView: UIImageView, size: CGFloat, count: Int) {
        if count > Constants.maxPlayerCount {
            let circleSize = size * 0.7 // Make circles 70% the size of spy icons
            imageView.layer.cornerRadius = circleSize / 2
            imageView.clipsToBounds = true
            imageView.tintColor = .white
            imageView.image = UIImage(systemName: "circle.fill")
            
            // Update constraints for the smaller circle size
            NSLayoutConstraint.deactivate(imageView.constraints)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: circleSize),
                imageView.heightAnchor.constraint(equalToConstant: circleSize)
            ])
        } else {
            imageView.layer.cornerRadius = 0
            imageView.image = UIImage(named: "spy-w")
            
            // Keep original size for spy icons
            NSLayoutConstraint.deactivate(imageView.constraints)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: size),
                imageView.heightAnchor.constraint(equalToConstant: size)
            ])
        }
    }
}
