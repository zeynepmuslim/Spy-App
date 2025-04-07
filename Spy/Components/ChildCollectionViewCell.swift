//
//  ChildCollectionViewCell.swift
//  Spy
//
//  Created by Zeynep Müslim on 6.04.2025.
//


import UIKit
import SwiftUI

// CollectionView'deki her bir öğeyi temsil eden hücre sınıfı.
class ChildCollectionViewCell: UICollectionViewCell {

    // Hücrenin yeniden kullanım için tanımlayıcısı (identifier).
    static let identifier = "ChildCollectionViewCell"

    
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let spacerView1 = UIView()
    private let spacerView2 = UIView()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5.0
        stack.alignment = .center
        return stack
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .red
        // Set explicit size for the icon
//        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        imageView.setContentHuggingPriority(.required, for: .horizontal)
//        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()

    // Padding constants
    private let padding: CGFloat = 8.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Add arranged subviews to stack view
        // Order matters for vertical layout
        stackView.addArrangedSubview(spacerView1)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(spacerView2)

        // Add stackView to contentView
        contentView.addSubview(stackView)

        // --- Constraints for StackView --- 
        // Center the stack view within the cell bounds, allowing for padding
        
        setupConstraints()

        contentView.layer.cornerRadius = 8 // Köşeleri yuvarlat
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),

            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    // Method to switch layout by changing stack view axis
    func updateLayout(isVertical: Bool, numberOfChild: Int) {
        if isVertical {
            stackView.axis = .vertical // küçüktür 6

            
            if numberOfChild == 4 {
                iconImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
                stackView.distribution = .equalSpacing
                label.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2).isActive = true
            } else {
                iconImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8).isActive = true
                stackView.distribution = .equalSpacing

            }
            label.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2).isActive = true

//            stackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true

            // Optional: Adjust distribution/alignment for vertical
            // stackView.distribution = .fillEqually
            // stackView.alignment = .center
        } else {
            stackView.axis = .horizontal
            iconImageView.widthAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1.5).isActive = true
            stackView.distribution = .equalSpacing
            // Optional: Adjust distribution/alignment for horizontal
            // stackView.alignment = .center
        }
        // No need to manually activate/deactivate constraints
        // MOVED: Manual constraint activation/deactivation logic
        // REMOVED: contentView.layoutIfNeeded()
    }

    // Hücreyi belirli bir çocuk ID'si, renk ve ikon ile yapılandırır.
    func configure(id: Int, color: UIColor, iconName: String) {
        label.text = "Child \(id)"
        contentView.backgroundColor = color
        iconImageView.image = UIImage(named: iconName)
    }

    // Hücre yeniden kullanılmadan önce temizlik yapmak için.
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        contentView.backgroundColor = .clear
        iconImageView.image = nil // Clear the image

        // Reset stack view axis maybe? Or rely on configure/updateLayout
        // stackView.axis = .vertical // Or horizontal, depending on default

        // REMOVED: Deactivation of manual constraints
        // print("Prepared cell for reuse - StackView") // Debugging
    }
}

// REMOVED: Helper extension for NSLayoutConstraint (no longer needed here)

// ÖNİZLEME: UICollectionView içinde ChildCollectionViewCell'i gösteren ViewController
struct ChildCellPreviewViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = context.coordinator
        collectionView.register(ChildCollectionViewCell.self, forCellWithReuseIdentifier: ChildCollectionViewCell.identifier)

        let viewController = UIViewController()
        viewController.view = collectionView

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No dynamic updates needed for now
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            5 // Örnek olarak 5 hücre
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChildCollectionViewCell.identifier, for: indexPath) as? ChildCollectionViewCell else {
                fatalError("Couldn't dequeue ChildCollectionViewCell")
            }
            let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple]
            cell.configure(id: indexPath.item + 1,
                           color: colors[indexPath.item % colors.count],
                           iconName:"spy-w")
            cell.updateLayout(isVertical: true, numberOfChild: 3) // veya false
            return cell
        }
    }
}

#Preview {
    ChildCellPreviewViewController()
}
