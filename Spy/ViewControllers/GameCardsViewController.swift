//
//  GameCardsViewController.swift
//  Spy
//
//  Created by Zeynep Müslim on 10.03.2025.

import SwiftUI
import UIKit

class GameCardsViewController: UIViewController, CustomCardViewDelegate {
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var cardViews: [CustomCardView] = []
    
    private let cardScale: CGFloat = 0.94
    private let verticalOffset: CGFloat = 25
    private let screenWidthMultiplier: CGFloat = 0.7
    
    private var playerCount: Int = 3
    private var spyCount: Int = 1
    private var spyIndices: Set<Int> = []
    private var category: String = ""
    private var roundDuration: String = ""
    private var roundCount: String = ""
    private var showHints: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientView = GradientView(superView: view)
        view.insertSubview(gradientView, at: 0)

        setupUI()
        setupCards()
    }
    
    func setGameParameters(playerCount: Int, spyCount: Int, category: String, roundDuration: String, roundCount: String, showHints: Bool) {
        self.playerCount = playerCount
        self.spyCount = spyCount
        self.category = category
        self.roundDuration = roundDuration
        self.roundCount = roundCount
        self.showHints = showHints
        
        var availableIndices = Array(0..<playerCount)
        spyIndices.removeAll()
        
        for _ in 0..<spyCount {
            let randomIndex = Int.random(in: 0..<availableIndices.count)
            spyIndices.insert(availableIndices[randomIndex])
            availableIndices.remove(at: randomIndex)
        }
        
        print("Game Setup:")
        print("Total Players: \(playerCount)")
        print("Spy Count: \(spyCount)")
        print("Spy Indices: \(spyIndices)")
        print("Category: \(category)")
        print("Round Duration: \(roundDuration)")
        print("Round Count: \(roundCount)")
        print("Show Hints: \(showHints)")
    }

    private func setupUI() {
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: screenWidthMultiplier),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: screenWidthMultiplier*2)
        ])
    }

    private func setupCards() {
        for i in 0..<playerCount {
            let cardView = CustomCardView()
            cardView.delegate = self
            cardView.translatesAutoresizingMaskIntoConstraints = false

            let isSpy = spyIndices.contains(i)
            cardView.configure(
                role: "Player \(i + 1)",
                selectedWord: "Tap to Reveal",
                label: "Swipe to Dismiss",
                isSpy: isSpy
            )

            containerView.insertSubview(cardView, at: 0)

            cardView.alpha = 0
            cardView.transform = CGAffineTransform(translationX: 0, y: -200)

            let scale = pow(cardScale, CGFloat(i))
            let yOffset = CGFloat(i) * -verticalOffset

            NSLayoutConstraint.activate([
                cardView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                cardView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                cardView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                cardView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
            ])

            cardViews.append(cardView)

            UIView.animate(withDuration: 0.6,
                         delay: Double(i) * 0.12,
                         usingSpringWithDamping: 0.7,
                         initialSpringVelocity: 0.5,
                         options: .curveEaseInOut) {
                cardView.alpha = 1
                let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                let translateTransform = CGAffineTransform(translationX: 0, y: yOffset)
                cardView.transform = scaleTransform.concatenating(translateTransform) // birleştirmek için kullanıyo hem öteleme hem boyut matrikslerini aynı anda uyguluyor
                cardView.layer.zPosition = CGFloat(self.playerCount - i)
            } completion: { _ in
                if i == 0 {
                    cardView.isInteractionEnabled = true
                }
            }
        }
    }

    func cardViewWasDismissed(_ cardView: CustomCardView) {
        if let index = cardViews.firstIndex(of: cardView) {
            cardViews.remove(at: index)

            cardViews.first?.isInteractionEnabled = true

            animateCardsPosition()
            
            if cardViews.isEmpty {
                performSegue(withIdentifier: "CardsToTimerStart", sender: nil)
            }
        }
    }

    private func animateCardsPosition() {
        for (index, card) in cardViews.enumerated() {
            let scale = pow(cardScale, CGFloat(index))
            let yOffset = CGFloat(index) * -verticalOffset

            UIView.animate(withDuration: 0.5,
                         delay: Double(index) * 0.05,
                         usingSpringWithDamping: 0.8,
                         initialSpringVelocity: 0.5,
                         options: .curveEaseInOut) {
                let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                let translateTransform = CGAffineTransform(translationX: 0, y: yOffset)
                card.transform = scaleTransform.concatenating(translateTransform)

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
