import UIKit
import SwiftUI

/// A view controller that manages game settings and player configuration.
/// This class handles the UI for setting up players and spies before starting the game.
class GameSettingsViewController: UIViewController {
    
    /// Constants used throughout the view controller
    private enum Constants {
        static let bigMargin: CGFloat = 20         // Large margin for main UI elements
        static let littleMargin: CGFloat = 5       // Small margin for minor spacing
        static let buttonsHeight: CGFloat = 40     // Height of control buttons
        static let initialIconSize: CGFloat = 50   // Initial size of player icons
        static let maxPlayerCount: Int = 6         // Maximum number of regular players
        static let animationDuration: TimeInterval = 0.3  // Duration for main animations
        static let fadeInDuration: TimeInterval = 0.15    // Duration for fade effects
        static let iconSpacing: CGFloat = 8        // Space between player icons
    }
    
    // MARK: - Properties
    
    /// Scrollable view containing the player configuration UI
    private let bottomView = CustomDarkScrollView()
    
    /// Manager handling player groups and their UI
    private let playerManager = PlayerGroupManager()
    
    /// Collection of player groups (regular players and spies)
    private var playerGroups: [PlayerGroupManager.PlayerGroup] = []
    
    /// UI Controls
    private lazy var backButton = BackButton(target: self, action: #selector(customBackAction))
    private lazy var startButton = createStartButton()
    private lazy var customizeButton = createCustomizeButton()
    private lazy var gradientView = GradientView(superView: view)
    
    // MARK: - Lifecycle Methods
    
    /// Sets up the initial UI state when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerGroups()
        setupInitialUI()
        setupConstraints()
        addInitialPlayers()
    }
    
    // MARK: - Private Setup Methods
    
    /// Initializes player groups for regular players and spies
    private func setupPlayerGroups() {
        playerGroups = [
            PlayerGroupManager.PlayerGroup(
                title: "Oyuncu Sayısı",
                target: self,
                index: 0,
                onRemove: { [weak self] in
                    guard let self = self else { return }
                    self.playerManager.removeLastIcon(from: self.playerGroups[0], animated: true)
                },
                onAdd: { [weak self] in
                    guard let self = self else { return }
                    self.playerManager.addNewIcon(to: self.playerGroups[0])
                }
            ),
            PlayerGroupManager.PlayerGroup(
                title: "Casus Sayısı",
                target: self,
                index: 1,
                onRemove: { [weak self] in
                    guard let self = self else { return }
                    self.playerManager.removeLastIcon(from: self.playerGroups[1], animated: true)
                },
                onAdd: { [weak self] in
                    guard let self = self else { return }
                    self.playerManager.addNewIcon(to: self.playerGroups[1])
                }
            )
        ]
    }
    
    /// Sets up the initial UI layout and hierarchy
    private func setupInitialUI() {
        [gradientView, backButton, bottomView, startButton].forEach { view.addSubview($0) }
        
        // Setup each player group
        var previousGroup: PlayerGroupManager.PlayerGroup?
        playerGroups.forEach { group in
            bottomView.addSubview(group.label)
            bottomView.addSubview(group.stackView)
            bottomView.addSubview(group.minusButton)
            bottomView.addSubview(group.plusButton)
            
            if let previous = previousGroup {
                // Setup constraints relative to previous group
                NSLayoutConstraint.activate([
                    group.label.topAnchor.constraint(equalTo: previous.stackView.bottomAnchor, constant: Constants.bigMargin),
                    group.stackView.topAnchor.constraint(equalTo: group.label.bottomAnchor, constant: Constants.littleMargin)
                ])
            } else {
                // First group constraints
                NSLayoutConstraint.activate([
                    group.label.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: Constants.bigMargin),
                    group.stackView.topAnchor.constraint(equalTo: group.label.bottomAnchor, constant: Constants.littleMargin)
                ])
            }
            
            // Common constraints for each group
            NSLayoutConstraint.activate([
                group.label.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Constants.bigMargin),
                group.label.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight),
                group.label.trailingAnchor.constraint(equalTo: group.minusButton.leadingAnchor, constant: -Constants.bigMargin),
                
                group.stackView.trailingAnchor.constraint(equalTo: group.minusButton.leadingAnchor, constant: -Constants.littleMargin),
                group.stackView.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight),
                group.stackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Constants.bigMargin),
                
                // Control buttons
                group.minusButton.centerYAnchor.constraint(equalTo: group.label.centerYAnchor),
                group.minusButton.trailingAnchor.constraint(equalTo: group.plusButton.leadingAnchor, constant: -8),
                
                group.plusButton.centerYAnchor.constraint(equalTo: group.label.centerYAnchor),
                group.plusButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -Constants.bigMargin)
            ])
            
            previousGroup = group
        }
        
        bottomView.addSubview(customizeButton)
    }
    
    /// Creates and configures the start game button
    private func createStartButton() -> CustomGradientButton {
        let button = CustomGradientButton(labelText: "Oyna", width: 100, height: 60)
        button.onClick = { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "gameSettingsToCards", sender: self)
        }
        return button
    }
    
    /// Creates and configures the customize button
    private func createCustomizeButton() -> CustomGradientButton {
        return CustomGradientButton(labelText: "Özelleştir", width: 200, height: Constants.buttonsHeight)
    }
    
    /// Adds initial players to both groups
    private func addInitialPlayers() {
        // Add initial regular players
        for _ in 0..<3 {
            playerManager.addNewIcon(to: playerGroups[0])
        }
        
        // Add initial spy
        playerManager.addNewIcon(to: playerGroups[1])
    }
    
    /// Sets up Auto Layout constraints for all UI elements
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Back Button
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Bottom View
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.bigMargin),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.bigMargin),
            bottomView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20),
            bottomView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            
            // Start Button
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.bigMargin),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.bigMargin),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Customize Button - Positioned below the first minus button
            customizeButton.topAnchor.constraint(equalTo: playerGroups[0].minusButton.bottomAnchor, constant: Constants.littleMargin),
            customizeButton.leadingAnchor.constraint(equalTo: playerGroups[0].minusButton.leadingAnchor),
            customizeButton.trailingAnchor.constraint(equalTo: playerGroups[0].plusButton.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    
    /// Handles the back button action
    @objc private func customBackAction() {
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - SwiftUI Preview
/// Provides a SwiftUI preview for the GameSettingsViewController
struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            GameSettingsViewController()
        }
    }
}
