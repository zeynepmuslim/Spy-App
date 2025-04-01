import SwiftUI
import UIKit
class GameSettingsViewController: UIViewController {
 
    private enum Constants {
        static let bigMargin: CGFloat = GeneralConstants.Layout.bigMargin
        static let littleMargin: CGFloat = GeneralConstants.Layout.littleMargin
        static let buttonsHeight: CGFloat = GeneralConstants.Button.miniHeight
    }

    private let bottomView = CustomDarkScrollView()
    private var playerGroups: [PlayerSettingsGroupManager.PlayerGroup] = []
    private var settingsGroups: [GameSettingsGroupManager.SettingsGroup] = []
    
    private var civilGroup: PlayerSettingsGroupManager.PlayerGroup? {
        playerGroups.first
    }
    
    private var spyGroup: PlayerSettingsGroupManager.PlayerGroup? {
        playerGroups.last
    }

    private lazy var backButton = BackButton(
        target: self, action: #selector(customBackAction))
    private lazy var startButton = createStartButton()
    private lazy var customizeButton = createCustomizeButton()
    private lazy var gradientView = GradientView(superView: view)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerGroups()
        setupSettingsGroups()
        setupInitialUI()
        setupConstraints()
    }
    
    private func setupPlayerGroups() {
        let updateButtons = { [weak self] in
            guard let self = self else { return }
            self.updateButtonStates()
        }
        
        playerGroups = [
            PlayerSettingsGroupManager.PlayerGroup(
                title: "Oyuncu Sayısı",
                target: self,
                index: 0,
                onRemove: updateButtons,
                onAdd: updateButtons,
                minSpyCount: 3,
                maxSpyCount: 10
            ),
            PlayerSettingsGroupManager.PlayerGroup(
                title: "Casus Sayısı",
                target: self,
                index: 1,
                onRemove: updateButtons,
                onAdd: updateButtons,
                buttonColor: .red,
                buttonShadow: .red,
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
    
    private func updateButtonStates() {
        guard let civilGroup = civilGroup, let spyGroup = spyGroup else { return }
        
        let playerCount = civilGroup.imageViews.count
        let spyCount = spyGroup.imageViews.count
        
        updateGroupButtonStates(group: spyGroup, count: spyCount, isSpyGroup: true)
        updateGroupButtonStates(group: civilGroup, count: playerCount, isSpyGroup: false)
    }
    
    private func updateGroupButtonStates(group: PlayerSettingsGroupManager.PlayerGroup, count: Int, isSpyGroup: Bool) {
        let activeStatus: ButtonStatus = isSpyGroup ? .activeRed : .activeBlue
        
        if count >= group.maxSpyCount {
            group.plusButton.setStatus(.deactive)
            group.plusButton.isUserInteractionEnabled = false
        } else {
            group.plusButton.setStatus(activeStatus)
            group.plusButton.isUserInteractionEnabled = true
        }
        
        if count <= group.minSpyCount {
            group.minusButton.setStatus(.deactive)
            group.minusButton.isUserInteractionEnabled = false
        } else {
            group.minusButton.setStatus(activeStatus)
            group.minusButton.isUserInteractionEnabled = true
        }
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
            // When this code runs:
            let previousSettingsGroup = settingsGroups[safe: settingsGroups.firstIndex(of: group)?.advanced(by: -1) ?? 0]
            // It's like saying:
            // "Find where 'group' appears in settingsGroups array"
            // The == operator is used internally to compare each group with 'group'
            // So it's comparing:
            // currentGroup == group
            // where:
            // - lhs (left-hand side) is the current group being checked
            // - rhs (right-hand side) is the 'group' we're looking for
            NSLayoutConstraint.activate([
                group.stackView.topAnchor.constraint(
                    equalTo: previousSettingsGroup?.stackView.bottomAnchor ?? bottomView.topAnchor,
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
                    equalTo: bottomView.topAnchor,
                    constant: Constants.bigMargin),
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
        if group === civilGroup {
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
            labelText: "Oyna", width: 100, height: GeneralConstants.Button.biggerHeight, isBorderlessButton: true)
        button.onClick = { [weak self] in
            guard let self = self else { return }
            
            if let civilGroup = self.civilGroup {
                print("Oyuncu Sayısı: \(civilGroup.imageViews.count)")
            }
            if let spyGroup = self.spyGroup {
                print("Casus Sayısı: \(spyGroup.imageViews.count)")
            }
            
            for (index, group) in self.settingsGroups.enumerated() {
                switch index {
                case 0:
                    print("Kategori: \(group.value)")
                case 1:
                    print("Tur Süresi: \(group.value)")
                case 2:
                    print("Tur Sayısı: \(group.value)")
                case 3:
                    if let switchStatus = group.switchButton?.isOn {
                        print("İpucunu Göster: \(switchStatus)")
                    }
                default:
                    break
                }
            }
            
            self.performSegue(
                withIdentifier: "gameSettingsToCards", sender: self)
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

            startButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.bigMargin),
            startButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.bigMargin),
            startButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            customizeButton.topAnchor.constraint(
                equalTo: civilGroup?.minusButton.bottomAnchor ?? bottomView.topAnchor,
                constant: Constants.littleMargin),
            customizeButton.leadingAnchor.constraint(
                equalTo: civilGroup?.minusButton.leadingAnchor ?? bottomView.leadingAnchor),
            customizeButton.trailingAnchor.constraint(
                equalTo: civilGroup?.plusButton.trailingAnchor ?? bottomView.trailingAnchor),
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
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            GameSettingsViewController()
        }
    }
}
