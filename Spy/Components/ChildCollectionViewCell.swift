//
//  ChildCollectionViewCell.swift
//  Spy
//
//  Created by Zeynep Müslim on 6.04.2025.
//


import UIKit
import SwiftUI

// CollectionView'deki her bir öğeyi temsil eden hücre sınıfı.
class ChildCollectionViewCell: UICollectionViewCell {
    var gradientColor: GradientColor
    var buttonColor: ButtonColor
    var shadowColor: ShadowColor
    var borderWidth: CGFloat
    
    private let titleLabel = UILabel()
    private var firstViewTopConstraint: NSLayoutConstraint!
    private var firstViewBottomConstraint: NSLayoutConstraint!
    private var firstViewLeadingConstraint: NSLayoutConstraint!
    private var firstViewTrailingConstraint: NSLayoutConstraint!
    private var gradientAnimationBorder: AnimatedGradientView!
    private var currentAnimator: UIViewPropertyAnimator?
    
    // Padding constraints
    private var stackViewTopConstraint: NSLayoutConstraint!
    private var stackViewBottomConstraint: NSLayoutConstraint!
    private var stackViewLeadingConstraint: NSLayoutConstraint!
    private var stackViewTrailingConstraint: NSLayoutConstraint!
    
    private var status: ButtonStatus = .activeBlue {
        didSet {
            // Only run the animation if the status actually changed.
            guard oldValue != status else { return }
            
            // Call the animated update when status changes
            animateAppearanceChange(to: status)
        }
    }
    // Hücrenin yeniden kullanım için tanımlayıcısı (identifier).
    static let identifier = "ChildCollectionViewCell"

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let spacerView1 = UIView()
    private let spacerView2 = UIView()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5.0
        stack.backgroundColor = ButtonColor.blue.color
        stack.layer.cornerRadius = GeneralConstants.Button.innerCornerRadius
        stack.alignment = .center
        return stack
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .red
        // Set explicit size for the icon
//        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        imageView.setContentHuggingPriority(.required, for: .horizontal)
//        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()

    // Padding constants
    private let padding: CGFloat = GeneralConstants.Button.borderWidth

    override init(frame: CGRect) {
        self.gradientColor = GradientColor.blue
        self.buttonColor = ButtonColor.blue
        self.shadowColor = ShadowColor.blue
        self.borderWidth = GeneralConstants.Button.borderWidth
        
        super.init(frame: frame)
        
        gradientAnimationBorder = AnimatedGradientView(width: contentView.frame.width * 1, height: contentView.frame.height * 1 , gradient: gradientColor)
        gradientAnimationBorder.layer.cornerRadius = GeneralConstants.Button.outerCornerRadius
        gradientAnimationBorder.clipsToBounds = true

        // Add arranged subviews to stack view
        // Order matters for vertical layout
        stackView.addArrangedSubview(spacerView1)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(spacerView2)

        // Add subviews in the correct order for layering
        contentView.addSubview(gradientAnimationBorder)
        contentView.addSubview(stackView)

        // Configure shadow directly to contentView layer
        contentView.layer.shadowColor = self.shadowColor.cgColor
        contentView.layer.shadowOpacity = GeneralConstants.Button.shadowOpacity
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1) // Example offset
        contentView.layer.shadowRadius = 5 // Use a different radius for shadow maybe? Or keep outerCornerRadius
        contentView.layer.masksToBounds = false // Ensure shadows aren't clipped

        // --- Constraints for StackView --- 
        // Center the stack view within the cell bounds, allowing for padding
        
        setupConstraints()

        contentView.layer.cornerRadius = GeneralConstants.Button.outerCornerRadius // Köşeleri yuvarlat
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        // Create constraints and store references
        stackViewLeadingConstraint = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding)
        stackViewTrailingConstraint = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding)
        stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        
        NSLayoutConstraint.activate([
            stackViewLeadingConstraint,
            stackViewTrailingConstraint,
            stackViewTopConstraint,
            stackViewBottomConstraint,

            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    // Method to switch layout by changing stack view axis
    func updateLayout(isVertical: Bool, numberOfChild: Int) {
        if isVertical {
            stackView.axis = .vertical // küçüktür 6

            
            if numberOfChild == 4 {
                iconImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
                stackView.distribution = .equalSpacing
                label.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2).isActive = true
            } else {
                iconImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8).isActive = true
                stackView.distribution = .equalSpacing

            }
            label.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2).isActive = true

//            stackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true

            // Optional: Adjust distribution/alignment for vertical
            // stackView.distribution = .fillEqually
            // stackView.alignment = .center
        } else {
            stackView.axis = .horizontal
            iconImageView.widthAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1).isActive = true
            stackView.distribution = .equalSpacing
            // Optional: Adjust distribution/alignment for horizontal
            // stackView.alignment = .center
        }
        // No need to manually activate/deactivate constraints
        // MOVED: Manual constraint activation/deactivation logic
        // REMOVED: contentView.layoutIfNeeded()
    }

    // Hücreyi belirli bir çocuk ID'si, renk ve ikon ile yapılandırır.
    func configure(id: Int, color: UIColor, iconName: String) {
        label.text = "Child \(id)"
        contentView.backgroundColor = color
        iconImageView.image = UIImage(named: iconName)
    }

    // Hücre yeniden kullanılmadan önce temizlik yapmak için.
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        contentView.backgroundColor = .clear
        iconImageView.image = nil // Clear the image

        // Reset stack view axis maybe? Or rely on configure/updateLayout
        // stackView.axis = .vertical // Or horizontal, depending on default

        // REMOVED: Deactivation of manual constraints
        // print("Prepared cell for reuse - StackView") // Debugging
    }
//    
//    private func animateLabelChange() {
//        UIView.transition(with: titleLabel, duration: GeneralConstants.Animation.duration, options: .transitionCrossDissolve, animations: {
//            self.titleLabel.text = self.labelText
//        }, completion: nil)
//    }
//    
    // Immediately updates the visual appearance without animation.
//    func updateAppearance(shadowColor: ShadowColor, gradientColor: GradientColor, buttonColor: ButtonColor) {
//        self.shadowColor = shadowColor
//        self.contentView.layer.shadowColor = shadowColor.cgColor
//        self.gradientAnimationBorder.updateGradient(to: gradientColor)
//        self.stackView.backgroundColor = buttonColor.color
//        // Ensure padding is reset to the default value if the animation was interrupted
//        self.stackViewTopConstraint.constant = self.padding
//        self.stackViewBottomConstraint.constant = -self.padding
//        self.stackViewLeadingConstraint.constant = self.padding
//        self.stackViewTrailingConstraint.constant = -self.padding
//    }
    
    // Renamed function to clarify it handles the animation driven by status change.
    private func animateAppearanceChange(to newStatus: ButtonStatus) {
        let totalDuration = GeneralConstants.Animation.duration
        let shadowColor = newStatus.shadowColor
        let gradientColor = newStatus.gradientColor
        let buttonColor = newStatus.buttonColor

        UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: [.allowUserInteraction], animations: {
            // Keyframe 1: Animate colors and shrink padding (0.0 to 0.5 duration)
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.shadowColor = shadowColor
                self.contentView.layer.shadowColor = shadowColor.cgColor
                self.gradientAnimationBorder.updateGradient(to: gradientColor)
                self.stackView.backgroundColor = buttonColor.color
                self.stackView.layer.cornerRadius = GeneralConstants.Button.outerCornerRadius
                
                // Animate padding constraints to 0
                self.stackViewTopConstraint.constant = 0
                self.stackViewBottomConstraint.constant = 0
                self.stackViewLeadingConstraint.constant = 0
                self.stackViewTrailingConstraint.constant = 0
                self.contentView.layoutIfNeeded() // Animate layout changes
            }
            
            // Keyframe 2: Restore padding (0.5 to 1.0 duration)
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                // Restore original padding values
                self.stackViewTopConstraint.constant = self.padding
                self.stackViewBottomConstraint.constant = -self.padding
                self.stackViewLeadingConstraint.constant = self.padding
                self.stackViewTrailingConstraint.constant = -self.padding
                self.stackView.layer.cornerRadius = GeneralConstants.Button.innerCornerRadius
                self.contentView.layoutIfNeeded() // Animate layout changes back
            }
        }, completion: nil)
    }

    
    func setStatus(_ newStatus: ButtonStatus) {
        status = newStatus
    }
    
    func getStatus() -> ButtonStatus {
        return status
    }
}

// REMOVED: Helper extension for NSLayoutConstraint (no longer needed here)

// ÖNİZLEME: UICollectionView içinde ChildCollectionViewCell'i gösteren ViewController
struct ChildCellPreviewViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = context.coordinator
        collectionView.register(ChildCollectionViewCell.self, forCellWithReuseIdentifier: ChildCollectionViewCell.identifier)

        let viewController = UIViewController()
        viewController.view = collectionView

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No dynamic updates needed for now
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            5 // Örnek olarak 5 hücre
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChildCollectionViewCell.identifier, for: indexPath) as? ChildCollectionViewCell else {
                fatalError("Couldn't dequeue ChildCollectionViewCell")
            }
            let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple]
            cell.configure(id: indexPath.item + 1,
                           color: colors[indexPath.item % colors.count],
                           iconName:"spy-w")
            cell.updateLayout(isVertical: true, numberOfChild: 3) // veya false
            return cell
        }
    }
}

#Preview {
    ChildCellPreviewViewController()
}
