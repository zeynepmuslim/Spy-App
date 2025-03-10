//
//  GameCardsViewController.swift
//  Spy
//
//  Created by Zeynep Müslim on 10.03.2025.
//

import UIKit

class GameCardsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientView = GradientView(superView: view)
        view.addSubview(gradientView)
    }
}
