//
//  GameCardsViewController.swift
//  Spy
//
//  Created by Zeynep Müslim on 10.03.2025.
//
import SwiftUI
import UIKit

class GameCardsViewController: UIViewController, CustomCardViewDelegate {
    // Card stack properties (adapted from CardViewController)
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var cardViews: [CustomCardView] = []
    private let numberOfCards = 5 // Example number of cards
    private let cardScale: CGFloat = 0.94
    private let verticalOffset: CGFloat = 25 // Adjusted offset
    private let screenWidthMultiplier: CGFloat = 0.7 // Adjusted size

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keep the gradient background
        let gradientView = GradientView(superView: view)
        view.insertSubview(gradientView, at: 0) // Insert gradient at the bottom

        setupUI()
        setupCards()
    }

    // Setup UI for the card container (adapted from CardViewController)
    private func setupUI() {
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: screenWidthMultiplier),
            // Make height slightly larger than width for typical card aspect ratio
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.4)
        ])
    }

    // Setup individual cards (adapted from CardViewController)
    private func setupCards() {
        for i in 0..<numberOfCards {
            let cardView = CustomCardView()
            cardView.delegate = self
            cardView.translatesAutoresizingMaskIntoConstraints = false

            // Configure labels with example data
            cardView.configure(text1: "Role \(i+1)", text2: "Tap to Reveal", text3: "Swipe to Dismiss")

            containerView.insertSubview(cardView, at: 0)

            // Initial animation setup
            cardView.alpha = 0
            cardView.transform = CGAffineTransform(translationX: 0, y: -200)

            let scale = pow(cardScale, CGFloat(i))
            let yOffset = CGFloat(i) * -verticalOffset

            // Use cardView's heightAnchor for constraints
            NSLayoutConstraint.activate([
                cardView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                cardView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                cardView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                cardView.heightAnchor.constraint(equalTo: containerView.heightAnchor) // Match container height
            ])

            cardViews.append(cardView)

            // Animate card entrance
            UIView.animate(withDuration: 0.6, // Slightly slower animation
                         delay: Double(i) * 0.12, // Slightly longer delay
                         usingSpringWithDamping: 0.7, // More spring
                         initialSpringVelocity: 0.5,
                         options: .curveEaseInOut) {
                cardView.alpha = 1
                // Apply both scale and translation
                let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                let translateTransform = CGAffineTransform(translationX: 0, y: yOffset)
                cardView.transform = scaleTransform.concatenating(translateTransform)
                cardView.layer.zPosition = CGFloat(self.numberOfCards - i) // Set z-index for proper stacking
            } completion: { _ in
                // Enable interaction only for the top card initially
                if i == 0 {
                    cardView.isInteractionEnabled = true
                }
            }
        }
    }

    // Delegate method (adapted from CardViewController)
    func cardViewWasDismissed(_ cardView: CustomCardView) {
        if let index = cardViews.firstIndex(of: cardView) {
            cardViews.remove(at: index)

            // Enable interaction for the new top card
            cardViews.first?.isInteractionEnabled = true

            // Re-animate the positions of remaining cards
            animateCardsPosition()
        }
    }

    // Animate card positions after dismissal (adapted from CardViewController)
    private func animateCardsPosition() {
        for (index, card) in cardViews.enumerated() {
            let scale = pow(cardScale, CGFloat(index))
            let yOffset = CGFloat(index) * -verticalOffset

            UIView.animate(withDuration: 0.5,
                         delay: Double(index) * 0.05, // Stagger the animation
                         usingSpringWithDamping: 0.8,
                         initialSpringVelocity: 0.5,
                         options: .curveEaseInOut) {
                // Apply both scale and translation
                let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                let translateTransform = CGAffineTransform(translationX: 0, y: yOffset)
                card.transform = scaleTransform.concatenating(translateTransform)

                // Ensure correct stacking order visually
                card.layer.zPosition = CGFloat(self.cardViews.count - index)
            }
        }
    }
}
struct ViewController_Previews6: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            GameCardsViewController()
        }
    }
}
