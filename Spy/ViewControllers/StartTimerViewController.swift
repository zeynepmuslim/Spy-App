//
//  StartTimerViewController.swift
//  Spy
//
//  Created by Zeynep Müslim on 2.04.2025.
//

// labelleri fonksiyon şejkliden yap

import SwiftUI
import UIKit

class StartTimerViewController: UIViewController {

    private let bottomView = CustomDarkScrollView()

    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    let words = [
        "Have you ever dreamed of this place?",
        "Can I smoke a cigarette right there?",
        "If you could stay there forever, would you?",
        "How many times have you been to this place in a year?",
    ]
    var spawnTimer: Timer?
    var activeLabelCenters: [CGPoint] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientView = GradientView(superView: view)
        view.addSubview(gradientView)
        view.addSubview(bottomView)

        titleLabel.text =
            "Süre bitmeden araınızdaki ajanı bulun! Yoksa ajan kazanır"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.text =
            "Herkes hazır olduğunda süreyi başlatmak içn ekrana dokun"
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        bottomView.addSubview(titleLabel)
        bottomView.addSubview(subtitleLabel)

        //yeterli mi emin olamadım
        view.bringSubviewToFront(bottomView)
        bottomView.bringSubviewToFront(titleLabel)
        bottomView.bringSubviewToFront(subtitleLabel)

        setupConstraints()
        spawnTimer = Timer.scheduledTimer(
            timeInterval: 2.0, target: self, selector: #selector(spawnLabel),
            userInfo: nil, repeats: true)
    }

    @objc func spawnLabel() {
        let word = words.randomElement() ?? "Hello"

        let label = UILabel()
        label.text = word
        label.textColor = .white
        label.textAlignment = .center

        let fontSize: CGFloat = CGFloat.random(in: 12...16)
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .thin)

        label.numberOfLines = 0
        let maxWidth: CGFloat = view.bounds.width * 0.3
        label.preferredMaxLayoutWidth = maxWidth
        label.lineBreakMode = .byWordWrapping
        label.frame.size = label.sizeThatFits(
            CGSize(width: maxWidth, height: .greatestFiniteMagnitude))

        let bottomFrame = bottomView.frame
        let fullBounds = view.bounds.insetBy(dx: 20, dy: 20)
        let forbiddenRect = bottomFrame.insetBy(dx: 30, dy: 30)

        // Etiketin yasaklı (koyu kutu) alana çakışıp çakışmadığını kontrol eder
        // Eğer çakışmıyorsa (intersects == false) → true döner → “Bu konum güvenli”.
        func isSafe(_ point: CGPoint, labelSize: CGSize) -> Bool {
            let labelFrame = CGRect(origin: point, size: labelSize)
            return !labelFrame.intersects(forbiddenRect)
        }

        let maxAttempts = 10
        var finalPosition: CGPoint?

        for _ in 0..<maxAttempts {
            let x = CGFloat.random(
                in: fullBounds.minX...(fullBounds.maxX - label.bounds.width))
            let y = CGFloat.random(
                in: fullBounds.minY...(fullBounds.maxY - label.bounds.height))
            // ?
            let center = CGPoint(
                x: x + label.bounds.width / 2, y: y + label.bounds.height / 2)
            let labelOrigin = CGPoint(x: x, y: y)

            let isFarEnough = activeLabelCenters.allSatisfy { existing in
                hypot(center.x - existing.x, center.y - existing.y) > 100
            }
            let isOutsideForbidden = isSafe(
                labelOrigin, labelSize: label.frame.size)

            if isFarEnough && isOutsideForbidden {
                finalPosition = labelOrigin
                activeLabelCenters.append(center)
                break
            }
        }
//?
        guard let position = finalPosition else { return }

        label.frame.origin = position
        label.alpha = 0.0
        label.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.addSubview(label)

        let animationDuration: TimeInterval = 5.0

        UIView.animate(
            withDuration: animationDuration, delay: 0,
            options: [.curveEaseInOut],
            animations: {
                label.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            })

        UIView.animateKeyframes(
            withDuration: animationDuration, delay: 0, options: [],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0, relativeDuration: 0.5
                ) {
                    label.alpha = 1.0
                }
                UIView.addKeyframe(
                    withRelativeStartTime: 0.5, relativeDuration: 0.5
                ) {
                    label.alpha = 0.0
                }
            },
            completion: { _ in
                label.removeFromSuperview()

                let centerToRemove = CGPoint(
                    x: position.x + label.bounds.width / 2,
                    y: position.y + label.bounds.height / 2
                )
                self.activeLabelCenters.removeAll { $0 == centerToRemove }
            })
    }

    deinit {
        spawnTimer?.invalidate()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bottomView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomView.widthAnchor.constraint(
                equalTo: view.widthAnchor, multiplier: 0.7),
            bottomView.heightAnchor.constraint(
                equalTo: view.widthAnchor, multiplier: 0.7),

            titleLabel.centerXAnchor.constraint(
                equalTo: bottomView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(
                equalTo: bottomView.centerYAnchor, constant: -40),
            titleLabel.widthAnchor.constraint(
                equalTo: bottomView.widthAnchor, multiplier: 0.8),

            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 40),
            subtitleLabel.centerXAnchor.constraint(
                equalTo: bottomView.centerXAnchor),
            subtitleLabel.widthAnchor.constraint(
                equalTo: bottomView.widthAnchor, multiplier: 0.8),
        ])
    }
}

struct EnterViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            StartTimerViewController()
        }
    }
}
