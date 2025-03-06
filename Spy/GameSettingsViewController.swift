//
//  GameSettingsViewController.swift
//  Spy
//
//  Created by Zeynep Müslim on 5.03.2025.
//

import UIKit
import SwiftUI

class GameSettingsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientView = GradientView(superView: view)
        let backButton = BackButton(target: self, action: #selector(customBackAction))
        
        view.addSubview(backButton)
        view.addSubview(gradientView)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    
    @objc func customBackAction() {
        dismiss(animated: true, completion: nil)
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
