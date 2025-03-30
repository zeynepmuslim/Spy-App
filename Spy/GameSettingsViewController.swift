import SwiftUI
import UIKit
class GameSettingsViewController: UIViewController {

    private enum Constants {
        static let bigMargin: CGFloat = 20
        static let littleMargin: CGFloat = 5
        static let buttonsHeight: CGFloat = 40
        static let maxPlayerCount: Int = 6
    }

    private let bottomView = CustomDarkScrollView()
    private var playerGroups: [PlayerGroupManager.PlayerGroup] = []
    
    private var civilGroup: PlayerGroupManager.PlayerGroup? {
        playerGroups.first
    }
    
    private var spyGroup: PlayerGroupManager.PlayerGroup? {
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
        setupInitialUI()
        setupConstraints()
    }
    
    private func setupPlayerGroups() {
        let updateButtons = { [weak self] in
            guard let self = self else { return }
            self.updateButtonStates()
        }
        
        playerGroups = [
            PlayerGroupManager.PlayerGroup(
                title: "Oyuncu Sayısı",
                target: self,
                index: 0,
                onRemove: updateButtons,
                onAdd: updateButtons,
                minSpyCount: 3,
                maxSpyCount: 10
            ),
            PlayerGroupManager.PlayerGroup(
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
    
    private func updateButtonStates() {
        guard let civilGroup = civilGroup, let spyGroup = spyGroup else { return }
        
        let playerCount = civilGroup.imageViews.count
        let spyCount = spyGroup.imageViews.count
        
        updateGroupButtonStates(group: spyGroup, count: spyCount, isSpyGroup: true)
        updateGroupButtonStates(group: civilGroup, count: playerCount, isSpyGroup: false)
    }
    
    private func updateGroupButtonStates(group: PlayerGroupManager.PlayerGroup, count: Int, isSpyGroup: Bool) {
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

        var previousGroup: PlayerGroupManager.PlayerGroup?
        playerGroups.forEach { group in
            addGroupToView(group, previousGroup: previousGroup)
            previousGroup = group
        }

        bottomView.addSubview(customizeButton)
    }
    
    private func addGroupToView(_ group: PlayerGroupManager.PlayerGroup, previousGroup: PlayerGroupManager.PlayerGroup?) {
        [group.label, group.stackView, group.minusButton, group.plusButton].forEach {
            bottomView.addSubview($0)
        }
        
        setupGroupConstraints(group, previousGroup: previousGroup)
    }
    
    private func setupGroupConstraints(_ group: PlayerGroupManager.PlayerGroup, previousGroup: PlayerGroupManager.PlayerGroup?) {
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
    
    private func setupGroupHorizontalConstraints(_ group: PlayerGroupManager.PlayerGroup) {
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
    
    private func setupGroupVerticalConstraints(_ group: PlayerGroupManager.PlayerGroup) {
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
            labelText: "Oyna", width: 100, height: 60)
        button.onClick = { [weak self] in
            guard let self = self else { return }
            self.performSegue(
                withIdentifier: "gameSettingsToCards", sender: self)
        }
        return button
    }

    private func createCustomizeButton() -> CustomGradientButton {
        return CustomGradientButton(
            labelText: "Özelleştir", width: 200, height: Constants.buttonsHeight
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
            bottomView.bottomAnchor.constraint(
                equalTo: startButton.topAnchor, constant: -20),
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
    }

    @objc private func customBackAction() {
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            GameSettingsViewController()
        }
    }
}
