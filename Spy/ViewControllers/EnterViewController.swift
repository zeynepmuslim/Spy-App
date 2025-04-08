//
//  ViewController.swift
//  Spy
//
//  Created by Zeynep Müslim on 4.03.2025.
//

import UIKit
import SwiftUI

class EnterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientView = GradientView(superView: view)
        view.addSubview(gradientView)
        
        let upperStack = UIView()
        upperStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(upperStack)
        
        let imageNames = ["footprint01", "footprint02", "footprint03"]
        for (index, imageName) in imageNames.enumerated() {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.zPosition = CGFloat(index)
            upperStack.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            ])
        }
        
        let startGameButton = CustomGradientButton(labelText: "Yeni Oyun",gradientColor: .red, width: 150,height: GeneralConstants.Button.biggerHeight ,shadowColor: .red, buttonColor: .red)
        let settingsButton = CustomGradientButton(labelText: "Ayarlar",height: GeneralConstants.Button.biggerHeight)
        let howToPlayButton = CustomGradientButton(labelText: "Nasıl Oynanır",height: GeneralConstants.Button.biggerHeight)
        
        let lowerStack = UIStackView()
        lowerStack.axis = .vertical
        lowerStack.spacing = 20
        lowerStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lowerStack)
        
        let titleLabel = UILabel()
        titleLabel.text = "SPY"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 70)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lowerStack.addSubview(titleLabel)
        
        lowerStack.addSubview(startGameButton)
        lowerStack.addSubview(settingsButton)
        lowerStack.addSubview(howToPlayButton)
        
        startGameButton.onClick = { [weak self] in
            guard let self = self else { return }
            print("Start Game Button Clicked!")
            self.performSegue(withIdentifier: "menuToGameSettings", sender: self)
        }
        
        settingsButton.onClick = {
            print("Settings Button Clicked!")
//            settingsButton.updateAppearance(shadowColor: .red, gradientColor: .red, buttonColor: .red)
//            settingsButton.labelText = "Button Clicked"
            self.performSegue(withIdentifier: "EnterToDefaultSettings", sender: self)
        }
        
        howToPlayButton.onClick = {
            print("How to Play Button Clicked!")
            self.performSegue(withIdentifier: "EnterToHowToPlay", sender: self)
        }
        
        
        NSLayoutConstraint.activate([
            upperStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            upperStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upperStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upperStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            lowerStack.topAnchor.constraint(equalTo: upperStack.bottomAnchor, constant: 20),
            lowerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lowerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lowerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lowerStack.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: lowerStack.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: lowerStack.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            startGameButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            startGameButton.centerXAnchor.constraint(equalTo: lowerStack.centerXAnchor),
            
            settingsButton.topAnchor.constraint(equalTo: startGameButton.bottomAnchor, constant:20),
            settingsButton.centerXAnchor.constraint(equalTo: lowerStack.centerXAnchor),
            
            howToPlayButton.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 20),
            howToPlayButton.centerXAnchor.constraint(equalTo: lowerStack.centerXAnchor),
            
        ])
    }
}


struct ViewController_Previews1: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            EnterViewController()
        }
    }
}
