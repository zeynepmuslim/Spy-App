import UIKit
import SwiftUI

class GameSettingsViewController: UIViewController {
    private let bottomView = CustomDarkScrollView()
    
    private let bigMargin : CGFloat = 20
    private let littleMargin : CGFloat = 5
    private let buttonsHeight : CGFloat = 40
//    let playerIconsContainer = UIStackView()
    
    let playerIconsContainer = UIStackView()
     var imageViews: [UIImageView] = []
     let maxStackWidth: CGFloat = 300 // StackView'in maksimum genişliği
     let initialIconSize: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupStackView()
               
               // Başlangıçta 3 resim ekleyelim
        for _ in 0..<3 {
            addNewIcon()
        }
        
        let gradientView = GradientView(superView: view)
        let backButton = BackButton(target: self, action: #selector(customBackAction))
        
        
        let playerNumberLabel = UILabel()
        playerNumberLabel.text = "Oyuncu Sayısı"
        playerNumberLabel.textColor = .white
        playerNumberLabel.font = UIFont.boldSystemFont(ofSize: 16)
        playerNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(playerNumberLabel)
        
        //PlayerNumber
        let minusButtonPN = CustomGradientButton(labelText: "-", width: buttonsHeight, height: buttonsHeight)
        minusButtonPN.onClick = {
            self.removeLastIcon(animated: true)
        }// As
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
        playerIconsContainer.backgroundColor = .red
        playerIconsContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(playerIconsContainer)
        
//        let icon1 = UIImageView(image: UIImage(systemName: "star.fill"))
//        let icon2 = UIImageView(image: UIImage(systemName: "star.fill"))
//        icon1.contentMode = .scaleAspectFill
//        icon1.backgroundColor = .blue
//        icon2.contentMode = .scaleAspectFit// Yeni nesne
//        playerIconsContainer.addArrangedSubview(icon1)
//        playerIconsContainer.addArrangedSubview(icon2)
        
        view.addSubview(gradientView)
        view.addSubview(backButton)
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: bigMargin),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -bigMargin),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            bottomView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            
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
//            playerIconsContainer.heightAnchor.constraint(equalToConstant: buttonsHeight),
            playerIconsContainer.leadingAnchor.constraint(equalTo: playerNumberLabel.leadingAnchor),
            playerIconsContainer.heightAnchor.constraint(equalToConstant: buttonsHeight),
            playerIconsContainer.widthAnchor.constraint(lessThanOrEqualTo: bottomView.widthAnchor, multiplier: 0.6)
//            playerIconsContainer.trailingAnchor.constraint(equalTo: customizeBUttonPN.leadingAnchor, constant: -bigMargin),
            
//            icon1.widthAnchor.constraint(equalTo: playerIconsContainer.widthAnchor, multiplier: 0.2),
        ])
    }
    
    @objc func customBackAction() {
//        addNewIcon()
//        addNewIcon()
//        dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
    }
    
    var iconConstraints: [NSLayoutConstraint] = []

//    @objc func addNewIcon() {
//        let icon = UIImageView(image: UIImage(systemName: "star.fill"))
//        icon.translatesAutoresizingMaskIntoConstraints = false
//        icon.contentMode = .scaleAspectFit
//        playerIconsContainer.addArrangedSubview(icon)
//
//        // İkon için genişlik Constraint'i ekleniyor
//        let iconWidthConstraint = icon.widthAnchor.constraint(equalToConstant: 30)
//        iconWidthConstraint.isActive = true
//        iconConstraints.append(iconWidthConstraint)
//    }
    
    func setupStackView() {
        playerIconsContainer.axis = .horizontal
        playerIconsContainer.alignment = .center
        playerIconsContainer.distribution = .fillEqually
        playerIconsContainer.spacing = 8
        
        view.addSubview(playerIconsContainer)
        
        playerIconsContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            playerIconsContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
        ])
    }
    

    
    func removeLastIcon(animated: Bool) {
        guard let lastImageView = imageViews.popLast() else { return }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                lastImageView.alpha = 0
                lastImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) // Shrink before removing
            }) { _ in
                lastImageView.removeFromSuperview()
                self.adjustIconSizes(animated: true) // Animate remaining icons
            }
        } else {
            lastImageView.removeFromSuperview()
            adjustIconSizes(animated: false)
        }
    }

    func addNewIcon() {
        let newImageView = UIImageView(image: UIImage(named: "spy"))
        newImageView.contentMode = .scaleAspectFit
        newImageView.tintColor = .systemBlue
        newImageView.alpha = 0
        newImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) // Start small
        
        imageViews.append(newImageView)
        playerIconsContainer.addArrangedSubview(newImageView)
        
        // Animate appearance
        UIView.animate(withDuration: 0.3, animations: {
            newImageView.alpha = 1
            newImageView.transform = .identity
        }) { _ in
            self.adjustIconSizes(animated: true) // Animate resizing
        }
    }

    func adjustIconSizes(animated: Bool) {
        let count = CGFloat(imageViews.count)
        let newSize = max(initialIconSize * (3.0 / count), 10)
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                for imageView in self.imageViews {
                    // Remove old constraints before adding new ones
                    NSLayoutConstraint.deactivate(imageView.constraints)

                    imageView.widthAnchor.constraint(equalToConstant: newSize).isActive = true
                    imageView.heightAnchor.constraint(equalToConstant: newSize).isActive = true
                    
                    if self.imageViews.count > 6 {
                        imageView.layer.cornerRadius = newSize / 2
                        imageView.clipsToBounds = true
                        imageView.image = UIImage(systemName: "circle.fill")
                    } else {
                        imageView.layer.cornerRadius = 0
                        imageView.image = UIImage(named: "spy")
                    }
                }
                self.playerIconsContainer.layoutIfNeeded() // Smooth layout updates
            })
        } else {
            for imageView in imageViews {
                NSLayoutConstraint.deactivate(imageView.constraints)

                imageView.widthAnchor.constraint(equalToConstant: newSize).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: newSize).isActive = true

                if imageViews.count > 6 {
                    imageView.layer.cornerRadius = newSize / 2
                    imageView.clipsToBounds = true
                    imageView.image = UIImage(systemName: "circle.fill")
                } else {
                    imageView.layer.cornerRadius = 0
                    imageView.image = UIImage(named: "spy")
                }
            }
            playerIconsContainer.layoutIfNeeded() // Immediate layout update
        }
    }
//    func adjustIconSizes() {
//        let count = CGFloat(imageViews.count)
//        let newSize = max(initialIconSize * (3.0 / count), 10)
//        
//        for imageView in imageViews {
//            imageView.widthAnchor.constraint(equalToConstant: newSize).isActive = true
//            imageView.heightAnchor.constraint(equalToConstant: newSize).isActive = true
//        }
//    }
}


struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            GameSettingsViewController()
        }
    }
}
