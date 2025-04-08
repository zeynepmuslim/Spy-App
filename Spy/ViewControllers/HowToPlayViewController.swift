//
//  HowToPlayViewController.swift
//  Spy
//
//  Created by Zeynep Müslim on 8.04.2025.
//

import UIKit
import SwiftUI


class HowToPlayViewController: UIViewController, CustomCardViewDelegate {
    
    private lazy var backButton = BackButton(
        target: self, action: #selector(customBackAction))
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var hintTitles: [String] = ["Başlık1", "Başlık2", "Başlık3","Başlık4", "Başlık5", "Başlık6","Başlık7", "Başlık8", "Başlık9", "Başlık 10"]
    
    private var hintTexts: [String] = ["Başlık111111", "Başlık22222222", "Başlık3333333","Başlık444444", "Başlık55555", "Başlık6666","Başlık7887", "Başlık8rytgf", "Başlıertgrtgk9", "Başlık etgbe10"]
    
    private var cardViews: [CustomCardView] = []
    
    private let cardScale: CGFloat = 0.94
    private let verticalOffset: CGFloat = 25
    private let screenWidthMultiplier: CGFloat = 0.7
    
    private var playerCount: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientView = GradientView(superView: view)
        view.insertSubview(gradientView, at: 0)
    
        view.addSubview(backButton)
        
        setupUI()
        setupCards()
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
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
            cardView.isFlipEnabled = false
            cardView.setStatus(.activeBlue)
            cardView.configure(role: "Card \(hintTitles[i])", selectedWord: "Instructions for this card. \(hintTexts[i])", label: "Sonraki ip ucu içiçn kaydır")
            cardView.translatesAutoresizingMaskIntoConstraints = false
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
                cardView.transform = scaleTransform.concatenating(translateTransform)
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
    
    @objc private func customBackAction() {
        self.performSegue(withIdentifier: "HowToPlayToEnter", sender: self)
    }
}

struct HowToPlayViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            HowToPlayViewController()
        }
    }
}
