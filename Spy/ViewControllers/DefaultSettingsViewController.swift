//
//  DefaultSettingsViewController.swift
//  Spy
//
//  Created by Zeynep Müslim on 8.04.2025.
//

import UIKit
import SwiftUI

class DefaultSettingsViewController: UIViewController {
    
    private enum Constants {
        static let bigMargin: CGFloat = GeneralConstants.Layout.bigMargin
        static let littleMargin: CGFloat = GeneralConstants.Layout.littleMargin
        static let buttonsHeight: CGFloat = GeneralConstants.Button.miniHeight
    }

    private let bottomView = CustomDarkScrollView()
    private var playerGroups: [PlayerSettingsGroupManager.PlayerGroup] = []
    private var settingsGroups: [GameSettingsGroupManager.SettingsGroup] = []
    
    private var playerGroup: PlayerSettingsGroupManager.PlayerGroup? {
        playerGroups.first
    }
    
    private var spyGroup: PlayerSettingsGroupManager.PlayerGroup? {
        playerGroups.last
    }
    
    let titleVCLabel = UILabel()

    private lazy var backButton = BackButton(
        target: self, action: #selector(customBackAction))
    private lazy var startButton = createStartButton()
    private lazy var customizeButton = createCustomizeButton()
    private lazy var gradientView = GradientView(superView: view)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleVCLabel.text = "Varsayılan Ayarlar"
        titleVCLabel.font = UIFont.systemFont(ofSize: GeneralConstants.Font.size05, weight: .bold)
        titleVCLabel.textColor = .spyBlue01
        titleVCLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.addSubview(titleVCLabel)
        
        setupPlayerGroups()
        setupSettingsGroups()
        setupInitialUI()
        setupConstraints()
    }
    
    private func setupPlayerGroups() {
        
        playerGroups = [
            PlayerSettingsGroupManager.PlayerGroup(
                title: "Oyuncu Sayısı",
                target: self,
                index: 0,
                minSpyCount: 1,
                maxSpyCount: 10
            ),
            PlayerSettingsGroupManager.PlayerGroup(
                title: "Casus Sayısı",
                target: self,
                index: 1,
                buttonBorderColor: .red,
                buttonShadow: .red,
                buttonColor: .red,
                minSpyCount: 1,
                maxSpyCount: 3
            ),
        ]
    }
    
    private func setupSettingsGroups() {
        settingsGroups = [
            GameSettingsGroupManager.createCategoryGroup(target: self),
            GameSettingsGroupManager.createRoundDurationGroup(target: self),
            GameSettingsGroupManager.createRoundCountGroup(target: self),
            GameSettingsGroupManager.createHintToggleGroup(target: self)
        ]
    }
    
    private func setupInitialUI() {
        [gradientView, backButton, bottomView, startButton].forEach {
            view.addSubview($0)
        }

        var previousGroup: PlayerSettingsGroupManager.PlayerGroup?
        playerGroups.forEach { group in
            addGroupToView(group, previousGroup: previousGroup)
            previousGroup = group
        }
        
        var lastPlayerGroup = playerGroups.last
        settingsGroups.forEach { group in
            addSettingsGroupToView(group, previousPlayerGroup: lastPlayerGroup)
            lastPlayerGroup = nil
        }

        bottomView.addSubview(customizeButton)
    }
    
    private func addGroupToView(_ group: PlayerSettingsGroupManager.PlayerGroup, previousGroup: PlayerSettingsGroupManager.PlayerGroup?) {
        [group.label, group.stackView, group.minusButton, group.plusButton].forEach {
            bottomView.addSubview($0)
        }
        
        setupGroupConstraints(group, previousGroup: previousGroup)
    }
    
    private func addSettingsGroupToView(_ group: GameSettingsGroupManager.SettingsGroup, previousPlayerGroup: PlayerSettingsGroupManager.PlayerGroup?) {
        bottomView.addSubview(group.stackView)
        
        if let previousGroup = previousPlayerGroup {
            NSLayoutConstraint.activate([
                group.stackView.topAnchor.constraint(
                    equalTo: previousGroup.stackView.bottomAnchor,
                    constant: Constants.bigMargin),
                group.stackView.leadingAnchor.constraint(
                    equalTo: bottomView.leadingAnchor,
                    constant: Constants.bigMargin),
                group.stackView.trailingAnchor.constraint(
                    equalTo: bottomView.trailingAnchor,
                    constant: -Constants.bigMargin)
            ])
        } else {
            let previousSettingsGroup = settingsGroups[safe: settingsGroups.firstIndex(of: group)?.advanced(by: -1) ?? 0]
            NSLayoutConstraint.activate([
                group.stackView.topAnchor.constraint(
                    equalTo: previousSettingsGroup?.stackView.bottomAnchor ?? titleVCLabel.bottomAnchor,
                    constant: Constants.bigMargin),
                group.stackView.leadingAnchor.constraint(
                    equalTo: bottomView.leadingAnchor,
                    constant: Constants.bigMargin),
                group.stackView.trailingAnchor.constraint(
                    equalTo: bottomView.trailingAnchor,
                    constant: -Constants.bigMargin)
            ])
        }
    }
    
    private func setupGroupConstraints(_ group: PlayerSettingsGroupManager.PlayerGroup, previousGroup: PlayerSettingsGroupManager.PlayerGroup?) {
        if let previous = previousGroup {
            NSLayoutConstraint.activate([
                group.label.topAnchor.constraint(
                    equalTo: previous.stackView.bottomAnchor,
                    constant: Constants.littleMargin),
                group.stackView.topAnchor.constraint(
                    equalTo: group.label.bottomAnchor,
                    constant: Constants.littleMargin),
            ])
        } else {
            NSLayoutConstraint.activate([
                group.label.topAnchor.constraint(
                    equalTo: titleVCLabel.bottomAnchor,
                    constant: Constants.littleMargin),
                group.stackView.topAnchor.constraint(
                    equalTo: group.label.bottomAnchor,
                    constant: Constants.littleMargin),
            ])
        }

        setupGroupHorizontalConstraints(group)
        setupGroupVerticalConstraints(group)
    }
    
    private func setupGroupHorizontalConstraints(_ group: PlayerSettingsGroupManager.PlayerGroup) {
        NSLayoutConstraint.activate([
            group.label.leadingAnchor.constraint(
                equalTo: bottomView.leadingAnchor,
                constant: Constants.bigMargin),
            group.label.heightAnchor.constraint(
                equalToConstant: Constants.buttonsHeight),
            group.label.trailingAnchor.constraint(
                equalTo: group.minusButton.leadingAnchor,
                constant: -Constants.bigMargin),

            group.stackView.trailingAnchor.constraint(
                equalTo: group.minusButton.leadingAnchor,
                constant: -Constants.littleMargin),
            group.stackView.heightAnchor.constraint(
                equalToConstant: Constants.buttonsHeight),
            group.stackView.leadingAnchor.constraint(
                equalTo: bottomView.leadingAnchor,
                constant: Constants.bigMargin),

            group.minusButton.trailingAnchor.constraint(
                equalTo: group.plusButton.leadingAnchor, constant: -8),
            group.plusButton.trailingAnchor.constraint(
                equalTo: bottomView.trailingAnchor,
                constant: -Constants.bigMargin),
            group.minusButton.widthAnchor.constraint(
                equalToConstant: Constants.buttonsHeight),
            group.plusButton.widthAnchor.constraint(
                equalToConstant: Constants.buttonsHeight),
        ])
    }
    
    private func setupGroupVerticalConstraints(_ group: PlayerSettingsGroupManager.PlayerGroup) {
        if group === playerGroup {
            NSLayoutConstraint.activate([
                group.minusButton.centerYAnchor.constraint(
                    equalTo: group.label.centerYAnchor),
                group.plusButton.centerYAnchor.constraint(
                    equalTo: group.label.centerYAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                group.minusButton.centerYAnchor.constraint(
                    equalTo: group.stackView.centerYAnchor,
                    constant: -Constants.bigMargin),
                group.plusButton.centerYAnchor.constraint(
                    equalTo: group.stackView.centerYAnchor,
                    constant: -Constants.bigMargin),
            ])
        }
    }

    private func createStartButton() -> CustomGradientButton {
        let button = CustomGradientButton(
            labelText: "Varsayılan Olarak Kaydet", width: 100, height: GeneralConstants.Button.biggerHeight)
        
        let playerCount = playerGroup?.imageViews.count ?? 0
        let spyCount = spyGroup?.imageViews.count ?? 0
        
        // Get other settings
        var category = ""
        var roundDuration = ""
        var roundCount = ""
        var showHints = false
        
        for (index, group) in settingsGroups.enumerated() {
            switch index {
            case 0:
                category = String(describing: group.value)
            case 1:
                roundDuration = String(describing: group.value)
            case 2:
                roundCount = String(describing: group.value)
            case 3:
                showHints = group.switchButton?.isOn ?? false
            default:
                break
            }
        }
        
        
        button.onClick = { [weak self] in
            guard let self = self else { return }
           customBackAction()
            
            print("Default Settings Setup:")
            print("Total Players: \(playerCount)")
            print("Spy Count: \(spyCount)")
            print("Category: \(category)")
            print("Round Duration: \(roundDuration)")
            print("Round Count: \(roundCount)")
            print("Show Hints: \(showHints)")
        }
        return button
    }

    private func createCustomizeButton() -> CustomGradientButton {
        return CustomGradientButton(
            labelText: "Özelleştir", width: 200, height: Constants.buttonsHeight, fontSize: GeneralConstants.Font.size01
        )
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            bottomView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.bigMargin),
            bottomView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.bigMargin),
            bottomView.topAnchor.constraint(
                equalTo: backButton.bottomAnchor, constant: 10),
            
            titleVCLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: Constants.bigMargin),
            titleVCLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Constants.bigMargin),
            titleVCLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -Constants.bigMargin),

            startButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.bigMargin),
            startButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.bigMargin),
            startButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            customizeButton.topAnchor.constraint(
                equalTo: playerGroup?.minusButton.bottomAnchor ?? bottomView.topAnchor,
                constant: Constants.littleMargin),
            customizeButton.leadingAnchor.constraint(
                equalTo: playerGroup?.minusButton.leadingAnchor ?? bottomView.leadingAnchor),
            customizeButton.trailingAnchor.constraint(
                equalTo: playerGroup?.plusButton.trailingAnchor ?? bottomView.trailingAnchor),
        ])

        // conditional bottom constraint
        if let lastSettingsGroup = settingsGroups.last {
            bottomView.bottomAnchor.constraint(
                equalTo: lastSettingsGroup.stackView.bottomAnchor, constant: 20).isActive = true
        } else {
            bottomView.bottomAnchor.constraint(
                equalTo: startButton.topAnchor, constant: -20).isActive = true
        }
    }

    @objc private func customBackAction() {
        self.performSegue(withIdentifier: "DefaultSettingsToEnter", sender: self)
    }
}

struct DefaultSettingsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            DefaultSettingsViewController()
        }
    }
}
