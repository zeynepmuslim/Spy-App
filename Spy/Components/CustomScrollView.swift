import UIKit

class CustomScrollView: UIView {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    init(cornerRadius: CGFloat) {
        super.init(frame: .zero)
        setupView(cornerRadius: cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(cornerRadius: CGFloat) {
        backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        // ScrollView ayarları
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        // StackView ayarları
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            // ScrollView'ı tüm view'e yay
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            // StackView'ı ScrollView içine yerleştir
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // StackView genişliğini ScrollView ile eşitle
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // StackView içine eleman ekleme fonksiyonu
    func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
}
