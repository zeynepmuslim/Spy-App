//
//  CountdownViewController.swift
//  Spy
//
//  Created by Zeynep Müslim on 4.04.2025.
//

import SwiftUI
import UIKit

class CountdownViewController: UIViewController {

    private enum Constants {
        static let bigMargin: CGFloat = GeneralConstants.Layout.bigMargin
        static let littleMargin: CGFloat = GeneralConstants.Layout.littleMargin
        static let buttonsHeight: CGFloat = GeneralConstants.Button.miniHeight
    }

    private lazy var gradientView = GradientView(superView: view)
    private let darkBottomView = CustomDarkScrollView()
    private lazy var blamePlayerButton = createBlamePlayerButton()

    //Time and Hint Seciton
    private var timeAndHintContainer = UIView()
    private var hintContainer = UIView()
    private var hintTitle = UILabel()
    private var hintLabel = UILabel()
    private var timeContainer = UIView()
    private var timeLabel = UILabel()

    //bottom Section
    private var topContainer = UIView()
    private var bottomContainer = UIView()

    private var findSpyContainer = UIView()
    private var findSpyTitle = UILabel()
    private var findSpyLabel = UILabel()

    private var pointsContainer = UIView()
    private var pointsTitle = UILabel()
    private var civilPointsLabel = UILabel()
    private var spyPointsLabel = UILabel()
    
    private var bottomLabel = UILabel()
    
    private var isHintAvailable = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        darkBottomView.addSubview(topContainer)
        
        findSpyContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(findSpyContainer)
        
        findSpyContainer.addSubview(findSpyTitle)
        findSpyContainer.addSubview(findSpyLabel)
        
        findSpyTitle.text = "Ajanı Bul!"
        findSpyTitle.textColor = .white
        findSpyTitle.textAlignment = .left
        findSpyTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        findSpyTitle.translatesAutoresizingMaskIntoConstraints = false
        
        findSpyLabel.text = "Suçlamak istediğin oyuncuyu seç"
        findSpyLabel.textColor = .spyBlue01
        findSpyLabel.textAlignment = .left
        findSpyLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        findSpyLabel.numberOfLines = 0
        findSpyLabel.lineBreakMode = .byWordWrapping
        findSpyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pointsTitle.text = "OYUNCU 1 SİVVİLDİ"
        pointsTitle.textColor = .white
        pointsTitle.text = pointsTitle.text?.uppercased()
        pointsTitle.textAlignment = .right
        pointsTitle.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        pointsTitle.translatesAutoresizingMaskIntoConstraints = false
        
        civilPointsLabel.text = "Her sivil için -1 puan"
        civilPointsLabel.textColor = .spyBlue01
        civilPointsLabel.textAlignment = .right
        civilPointsLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        civilPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        spyPointsLabel.text = "Ajan için +1 puan"
        spyPointsLabel.textColor = .spyRed01
        spyPointsLabel.textAlignment = .right
        spyPointsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        spyPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pointsContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(pointsContainer)
        pointsContainer.addSubview(pointsTitle)
        pointsContainer.addSubview(civilPointsLabel)
        pointsContainer.addSubview(spyPointsLabel)
        
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        darkBottomView.addSubview(bottomContainer)
        
        bottomContainer.addSubview(bottomLabel)
        bottomLabel.text = "Yanlış suçlama sivillerin alacğı toplam puanı düşürürken ajanınkini arttırır!"
        bottomLabel.textColor = .white
        bottomLabel.textAlignment = .left
        bottomLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        bottomLabel.numberOfLines = 2
        bottomLabel.lineBreakMode = .byWordWrapping
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupInitialUI()
        setupTimeAndHintUI()
        setupConstraints()
    }

    private func setupInitialUI() {
        [gradientView, darkBottomView, blamePlayerButton, timeAndHintContainer].forEach {
                view.addSubview($0)
        }
    }

    private func setupTimeAndHintUI() {

            timeAndHintContainer.addSubview(hintContainer)
            timeAndHintContainer.addSubview(timeContainer)
        
        if isHintAvailable {
            timeAndHintContainer.addSubview(hintContainer)
            [hintTitle, hintLabel].forEach {
                hintContainer.addSubview($0)
            }
        }
        
        timeContainer.addSubview(timeLabel)

        hintTitle.text = "Örnek Sorular"
        hintTitle.textColor = .white
        hintTitle.textAlignment = .center
        hintTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        hintTitle.translatesAutoresizingMaskIntoConstraints = false

        hintLabel.text = "Brada sigara içmeye izin var mı?"
        hintLabel.textColor = .white
        hintLabel.textAlignment = .center
        hintLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        hintLabel.numberOfLines = 0
        hintLabel.lineBreakMode = .byWordWrapping
        hintLabel.translatesAutoresizingMaskIntoConstraints = false

        timeLabel.text = "2:28"
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 70, weight: .black)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        timeAndHintContainer.translatesAutoresizingMaskIntoConstraints = false
        
        hintContainer.translatesAutoresizingMaskIntoConstraints = false
        timeContainer.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            timeAndHintContainer.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.bigMargin),
            timeAndHintContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.bigMargin),
            timeAndHintContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.bigMargin),
            timeAndHintContainer.bottomAnchor.constraint(
                equalTo: darkBottomView.topAnchor,
                constant: -Constants.bigMargin),

           

            timeContainer.leadingAnchor.constraint(
                equalTo: timeAndHintContainer.leadingAnchor),
            timeContainer.trailingAnchor.constraint(
                equalTo: timeAndHintContainer.trailingAnchor),
            timeContainer.topAnchor.constraint(
                equalTo: hintContainer.bottomAnchor),
            timeContainer.bottomAnchor.constraint(
                equalTo: timeAndHintContainer.bottomAnchor),

            timeLabel.leadingAnchor.constraint(
                equalTo: timeAndHintContainer.leadingAnchor),
            timeLabel.trailingAnchor.constraint(
                equalTo: timeAndHintContainer.trailingAnchor),
            timeLabel.centerYAnchor.constraint(
                equalTo: timeContainer.centerYAnchor),

            //
            darkBottomView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.bigMargin),
            darkBottomView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.bigMargin),
            darkBottomView.bottomAnchor.constraint(
                equalTo: blamePlayerButton.topAnchor,
                constant: -Constants.bigMargin),
            darkBottomView.heightAnchor.constraint(
                equalTo: view.heightAnchor, multiplier: 0.55),
            
            topContainer.leadingAnchor.constraint(
                equalTo: darkBottomView.leadingAnchor, constant: Constants.bigMargin),
            topContainer.trailingAnchor.constraint(
                equalTo: darkBottomView.trailingAnchor, constant: -Constants.bigMargin),
            topContainer.topAnchor.constraint(
                equalTo: darkBottomView.topAnchor, constant: Constants.bigMargin),
            topContainer.heightAnchor.constraint(
                equalTo: darkBottomView.heightAnchor, multiplier: 0.25),
            
            findSpyContainer.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor),
            findSpyContainer.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.4),
            findSpyContainer.topAnchor.constraint(equalTo: topContainer.topAnchor),
            findSpyContainer.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor),
            
            findSpyTitle.leadingAnchor.constraint(equalTo: findSpyContainer.leadingAnchor),
            findSpyTitle.topAnchor.constraint(equalTo: findSpyContainer.topAnchor),
            
            findSpyLabel.leadingAnchor.constraint(equalTo: findSpyContainer.leadingAnchor),
            findSpyLabel.topAnchor.constraint(equalTo: findSpyTitle.bottomAnchor, constant: Constants.littleMargin),
            findSpyLabel.widthAnchor.constraint(equalTo: findSpyContainer.widthAnchor),
            
            pointsContainer.leadingAnchor.constraint(equalTo: findSpyContainer.trailingAnchor),
            pointsContainer.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
            pointsContainer.topAnchor.constraint(equalTo: topContainer.topAnchor),
            pointsContainer.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor),
            
            pointsTitle.trailingAnchor.constraint(equalTo: pointsContainer.trailingAnchor),
            pointsTitle.topAnchor.constraint(equalTo: pointsContainer.topAnchor),
            
            civilPointsLabel.trailingAnchor.constraint(equalTo: pointsContainer.trailingAnchor),
            civilPointsLabel.topAnchor.constraint(equalTo: pointsTitle.bottomAnchor, constant: Constants.littleMargin),
            
            spyPointsLabel.trailingAnchor.constraint(equalTo: pointsContainer.trailingAnchor),
            spyPointsLabel.topAnchor.constraint(equalTo: civilPointsLabel.bottomAnchor, constant: 0),
            
            bottomContainer.leadingAnchor.constraint(
                equalTo: darkBottomView.leadingAnchor, constant: Constants.bigMargin),
            bottomContainer.trailingAnchor.constraint(
                equalTo: darkBottomView.trailingAnchor, constant: -Constants.bigMargin),
            bottomContainer.bottomAnchor.constraint(
                equalTo: darkBottomView.bottomAnchor, constant: -Constants.bigMargin),
            bottomContainer.heightAnchor.constraint(
                equalTo: darkBottomView.heightAnchor, multiplier: 0.07),
            
            bottomLabel.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor),
            bottomLabel.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor),

            blamePlayerButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.bigMargin),
            blamePlayerButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.bigMargin),
            blamePlayerButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
        ])

        if isHintAvailable {
            hintContainer.leadingAnchor.constraint(
                equalTo: timeAndHintContainer.leadingAnchor).isActive = true
            hintContainer.trailingAnchor.constraint(
                equalTo: timeAndHintContainer.trailingAnchor).isActive = true
            hintContainer.topAnchor.constraint(
                equalTo: timeAndHintContainer.topAnchor).isActive = true
            hintContainer.heightAnchor.constraint(
                equalTo: timeAndHintContainer.heightAnchor, multiplier: 0.3).isActive = true

            hintTitle.leadingAnchor.constraint(
                equalTo: hintContainer.leadingAnchor).isActive = true
            hintTitle.trailingAnchor.constraint(
                equalTo: hintContainer.trailingAnchor).isActive = true
            hintTitle.centerXAnchor.constraint(
                equalTo: hintContainer.centerXAnchor).isActive = true
            hintTitle.topAnchor.constraint(
                equalTo: hintContainer.topAnchor,
                constant: Constants.littleMargin).isActive = true

            hintLabel.widthAnchor.constraint(
                equalTo: hintContainer.widthAnchor, multiplier: 0.9).isActive = true
            hintLabel.topAnchor.constraint(
                equalTo: hintTitle.bottomAnchor,
                constant: Constants.littleMargin).isActive = true
            hintLabel.centerXAnchor.constraint(
                equalTo: hintContainer.centerXAnchor).isActive = true
        } else {
            
        }
        
    }

    private func createBlamePlayerButton() -> CustomGradientButton {
        let button = CustomGradientButton(
            labelText: "Oyuncu Suçla!", width: 100,
            height: GeneralConstants.Button.biggerHeight)
        button.onClick = { [weak self] in
            guard let self = self else { return }
            self.performSegue(
                withIdentifier: "TimerStarttoCountdown", sender: self)
        }
        return button
    }
}

struct VCountdownViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            CountdownViewController()
        }
    }
}
