import UIKit
import SwiftUI

class GameSettingsViewController: UIViewController {
    private let bottomView = CustomDarkScrollView()
    
    private let bigMargin : CGFloat = 20
    private let littleMargin : CGFloat = 5
    private let buttonsHeight : CGFloat = 40
    
    let playerIconsContainer = UIStackView()
    var imageViews: [UIImageView] = []
    let initialIconSize: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupStackView()
        
        for _ in 0..<3 {
            addNewIcon()
        }
        
        let gradientView = GradientView(superView: view)
        let backButton = BackButton(target: self, action: #selector(customBackAction))
        
        let startButton = CustomGradientButton(labelText: "Oyna", width: 100, height: 60)
        startButton.onClick = {
        }
        bottomView.addSubview(startButton)
        startButton.onClick = { [weak self] in
            guard let self = self else { return }
            print("Start Game Button Clicked! at settins")
            self.performSegue(withIdentifier: "gameSettingsToCards", sender: self)
        }
        
        
        let playerNumberLabel = UILabel()
        playerNumberLabel.text = "Oyuncu Sayısı"
        playerNumberLabel.textColor = .white
        playerNumberLabel.font = UIFont.boldSystemFont(ofSize: 16)
        playerNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(playerNumberLabel)
        
        let minusButtonPN = CustomGradientButton(labelText: "-", width: buttonsHeight, height: buttonsHeight)
        minusButtonPN.onClick = {
            self.removeLastIcon(animated: true)
        }
        bottomView.addSubview(minusButtonPN)
        
        
        let plusButtonPN = CustomGradientButton(labelText: "+", width: buttonsHeight, height: buttonsHeight)
        plusButtonPN.onClick = {
            self.addNewIcon()
        }
        bottomView.addSubview(plusButtonPN)
        
        let customizeBUttonPN = CustomGradientButton(labelText: "Özelleştir", width: 100, height: buttonsHeight)
        bottomView.addSubview(customizeBUttonPN)
        
        
        playerIconsContainer.axis = .horizontal
        playerIconsContainer.spacing = 8
        playerIconsContainer.alignment = .center
        playerIconsContainer.distribution = .fill
        playerIconsContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(playerIconsContainer)

        view.addSubview(gradientView)
        view.addSubview(backButton)
        view.addSubview(bottomView)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: bigMargin),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -bigMargin),
            bottomView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20),
            bottomView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: bigMargin),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -bigMargin),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            playerNumberLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: bigMargin),
            playerNumberLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: bigMargin),
            playerNumberLabel.trailingAnchor.constraint(equalTo: customizeBUttonPN.leadingAnchor, constant: -bigMargin),
            playerNumberLabel.heightAnchor.constraint(equalToConstant: buttonsHeight),
            
            minusButtonPN.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: bigMargin),
            minusButtonPN.trailingAnchor.constraint(equalTo: plusButtonPN.leadingAnchor, constant: -8),
            
            plusButtonPN.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: bigMargin),
            plusButtonPN.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -bigMargin),
            
            customizeBUttonPN.topAnchor.constraint(equalTo: plusButtonPN.bottomAnchor, constant: littleMargin),
            customizeBUttonPN.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -bigMargin),
            
            playerIconsContainer.topAnchor.constraint(equalTo: playerNumberLabel.bottomAnchor, constant: littleMargin),
            playerIconsContainer.leadingAnchor.constraint(equalTo: playerNumberLabel.leadingAnchor),
            playerIconsContainer.heightAnchor.constraint(equalToConstant: buttonsHeight),
            playerIconsContainer.widthAnchor.constraint(lessThanOrEqualTo: bottomView.widthAnchor, multiplier: 0.6)
        ])
    }
    
    @objc func customBackAction() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    var iconConstraints: [NSLayoutConstraint] = []
    
    
    func setupStackView() {
        playerIconsContainer.axis = .horizontal
        playerIconsContainer.alignment = .center
        playerIconsContainer.distribution = .fillEqually
        playerIconsContainer.spacing = 8
        
        view.addSubview(playerIconsContainer)
        
        playerIconsContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        ])
    }
    
    func removeLastIcon(animated: Bool) {
        guard let lastImageView = imageViews.popLast() else { return }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                lastImageView.alpha = 0
                lastImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) { _ in
                lastImageView.removeFromSuperview()
                self.adjustIconSizes(animated: true)
            }
        } else {
            lastImageView.removeFromSuperview()
            adjustIconSizes(animated: false)
        }
    }
    
    func addNewIcon() {
        let newImageView = UIImageView(image: UIImage(named: "spy-w"))
        newImageView.contentMode = .scaleAspectFit
        newImageView.tintColor = .systemBlue
        newImageView.frame.size = CGSize(width: 5, height: 5)
        newImageView.alpha = 0
        
        // Calculate the correct size before adding
        let count = CGFloat(imageViews.count + 1) // Include the new icon in count
        let calculatedSize = initialIconSize * (3.0 / count)
        let newSize = min(calculatedSize, initialIconSize)
        
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newImageView.widthAnchor.constraint(equalToConstant: newSize),
            newImageView.heightAnchor.constraint(equalToConstant: newSize)
        ])
        
        // Position the new icon at the right edge of the container
        let containerWidth = playerIconsContainer.bounds.width
        // Get y position from existing icons or use container center if no icons exist
        let yOffset = imageViews.first?.frame.minY ?? playerIconsContainer.bounds.height / 2
        newImageView.transform = CGAffineTransform(translationX: containerWidth / 10, y: yOffset)
        
        imageViews.append(newImageView)
        playerIconsContainer.addArrangedSubview(newImageView)
        
        // First shrink existing icons if needed
        self.adjustIconSizes(animated: true)
        
        // First animation: Move to position
        UIView.animate(withDuration: 0.2, 
                      delay: 0,
                      options: .curveEaseOut,
                      animations: {
            newImageView.transform = .identity
        }) { _ in
            // Second animation: Fade in after reaching position
            UIView.animate(withDuration: 0.15,
                         delay: 0,
                         options: .curveLinear,
                         animations: {
                newImageView.alpha = 1
            })
        }
    }
    
    func adjustIconSizes(animated: Bool) {
        let count = CGFloat(imageViews.count)
        let calculatedSize = initialIconSize * (3.0 / count)
        // Never allow size to increase above initialIconSize
        let newSize = min(calculatedSize, initialIconSize)
        
        let animationBlock = {
            for imageView in self.imageViews {
                NSLayoutConstraint.deactivate(imageView.constraints)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalToConstant: newSize),
                    imageView.heightAnchor.constraint(equalToConstant: newSize)
                ])
                
                if self.imageViews.count > 6 {
                    imageView.layer.cornerRadius = newSize / 3
                    imageView.clipsToBounds = true
                    imageView.tintColor = .white
                    imageView.image = UIImage(systemName: "circle.fill")
                } else {
                    imageView.layer.cornerRadius = 0
                    imageView.image = UIImage(named: "spy-w")
                }
            }
            self.playerIconsContainer.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, 
                         delay: 0,
                         options: .curveEaseOut,
                         animations: animationBlock)
        } else {
            animationBlock()
        }
    }
}


struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            GameSettingsViewController()
        }
    }
}
