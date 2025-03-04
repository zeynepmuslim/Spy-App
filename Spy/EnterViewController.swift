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
        let customDecoratedView = CustomGradientButton(shadowColor: .red)
        customDecoratedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customDecoratedView)
        
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
        
        let firstView = UIView()
        firstView.backgroundColor = .spyBlue04
        firstView.layer.cornerRadius = 8
        firstView.translatesAutoresizingMaskIntoConstraints = false
        lowerStack.addSubview(firstView)
        
        let thirdView = UIView()
        thirdView.backgroundColor = .gray
        thirdView.layer.shadowColor = UIColor.spyBlue01.cgColor
        thirdView.layer.shadowOpacity = 1.0
        thirdView.layer.shadowOffset = CGSize(width: 0, height: 1)
        thirdView.layer.shadowRadius = 10
        thirdView.layer.cornerRadius = 10
        thirdView.translatesAutoresizingMaskIntoConstraints = false
        lowerStack.addSubview(thirdView)
        
        let button1 = createButton(title: "jbhuhuh")
        let button2 = createButton(title: "Option 2")
        let button3 = createButton(title: "Option 3")
        
        lowerStack.addSubview(button1)
        lowerStack.addSubview(button2)
        lowerStack.addSubview(button3)
        lowerStack.addSubview(customDecoratedView)
        
        
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
            
            button1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            button1.centerXAnchor.constraint(equalTo: lowerStack.centerXAnchor),
            
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant:20),
            button2.centerXAnchor.constraint(equalTo: lowerStack.centerXAnchor),
            
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20),
            button3.centerXAnchor.constraint(equalTo: lowerStack.centerXAnchor),
            
            customDecoratedView.topAnchor.constraint(equalTo: button3.bottomAnchor, constant: 20),
            customDecoratedView.centerXAnchor.constraint(equalTo: lowerStack.centerXAnchor),
            
        ])
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }
    
    @objc func buttonTapped() {
        print("Button was tapped!")
    }
    
}


struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            EnterViewController()
        }
    }
}
