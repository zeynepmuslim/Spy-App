//
//  CountdownViewController.swift
//  Spy
//
//  Created by Zeynep Müslim on 4.04.2025.
//

import SwiftUI
import UIKit

class CountdownViewController: UIViewController {

    private enum Constants {
        static let bigMargin: CGFloat = GeneralConstants.Layout.bigMargin
        static let littleMargin: CGFloat = GeneralConstants.Layout.littleMargin
        static let buttonsHeight: CGFloat = GeneralConstants.Button.biggerHeight
    }

    private lazy var gradientView = GradientView(superView: view)
    private let darkBottomView = CustomDarkScrollView()
    private lazy var blamePlayerButton = createBlamePlayerButton()

    //Time and Hint Seciton
    private var timeAndHintContainer = UIView()
    private var hintContainer = UIView()
    private var hintTitle = UILabel()
    private var hintLabel = UILabel()
    private var timeContainer = UIView()
    private var timeLabel = UILabel()

    //bottom Section
    private var topContainer = UIView()
    private var bottomContainer = UIView()

    private var findSpyContainer = UIView()
    private var findSpyTitle = UILabel()
    private var findSpyLabel = UILabel()

    private var pointsContainer = UIView()
    private var pointsTitle = UILabel()
    private var civilPointsLabel = UILabel()
    private var spyPointsLabel = UILabel()
    
    var numberOfChildren: Int = 3
    private let centeredFlowLayout = CenteredFlowLayout()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: centeredFlowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false // Auto Layout için gerekli
        cv.backgroundColor = .clear // Arka planı şeffaf yap, konteyner rengi görünsün.
        // Kullanılacak hücre tipini CollectionView'e kaydet.
        cv.register(ChildCollectionViewCell.self, forCellWithReuseIdentifier: ChildCollectionViewCell.identifier)
        cv.dataSource = self // Veri kaynağı olarak bu sınıfı ata (aşağıdaki extension).
        cv.delegate = self // Delegate olarak bu sınıfı ata (aşağıdaki extension).
        cv.allowsMultipleSelection = false // Ensure only one selection is possible visually
        return cv
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1 // Kenarlık kalınlığı
        view.layer.borderColor = UIColor.lightGray.cgColor // Kenarlık rengi
        view.backgroundColor = .white // Konteynerin arka plan rengi
        return view
    }()
    
    private var currentColumns: Int = 3
    private var lastKnownCollectionViewSize: CGSize = .zero
    private var selectedIndex: IndexPath? = nil
    
    private var bottomLabel = UILabel()
    
    private var isHintAvailable = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkBottomView.addSubview(containerView)
        containerView.addSubview(collectionView)
        
        setupInitialUI()
        setupTimeAndHintUI()
        setupBottomViewLabelsUI()
        setupConstraints()
        
        currentColumns = determineColumns(for: numberOfChildren)
        configureLayout(columns: currentColumns)
        collectionView.reloadData() 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let currentSize = collectionView.bounds.size // CollectionView'in mevcut boyutunu al.
        // Boyut geçerliyse (sıfır değil) VE önceki bilinen boyuttan farklıysa...
        if currentSize != .zero && currentSize != lastKnownCollectionViewSize {
            print("CollectionView boyutu değişti: \(currentSize), layout geçersiz kılınıyor ve veri yeniden yükleniyor.")
            lastKnownCollectionViewSize = currentSize // Son bilinen boyutu güncelle.

            // 1. Layout'u GEÇERSİZ KIL: Bu, sizeForItemAt'in yeni (doğru) boyutları kullanmasını sağlar.
            centeredFlowLayout.invalidateLayout()
            // 2. Veriyi YENİDEN YÜKLE: Hücrelerin doğru boyutlarla oluşturulması için invalidate'den SONRA çağır.
            //collectionView.reloadData() // REMOVED: Data doesn't change anymore
            // 3. Layout'u ZORLA: Veri yüklendikten ve layout geçersiz kılındıktan SONRA değişikliklerin hemen uygulanmasını sağla.
            //collectionView.layoutIfNeeded() // REMOVED: Invalidate is sufficient
        }
    }

    private func determineColumns(for count: Int) -> Int {
        // Özel durum: Çocuk sayısı tam olarak 4 ise 2 sütun kullan (2x2 grid).
        if count == 4 {
            return 2
        }
        // Diğer durumlar için mevcut kuralı uygula:
        // 6 veya daha az (ve 4 değil) ise 3 sütun, 7 veya daha fazla ise 2 sütun.
        return (count <= 6) ? 3 : 2
    }

    // CollectionView'in FlowLayout'unu (bizim durumumuzda CenteredFlowLayout) belirtilen sütun sayısına göre yapılandırır.
    private func configureLayout(columns: Int) {
        // CollectionView'in layout nesnesini al (CenteredFlowLayout olduğundan emin ol).
        guard let layout = collectionView.collectionViewLayout as? CenteredFlowLayout else { return }

        // Bu VC'nin mevcut sütun bilgisini de güncelle.
        self.currentColumns = columns

        // Yatay ve dikey boşluk sabitleri.
        let horizontalPadding: CGFloat = 10
        let verticalPadding: CGFloat = 10

        // Layout'un temel parametrelerini ayarla:
        // Kenar boşlukları (sectionInset: üst, sol, alt, sağ).
        layout.sectionInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        // Öğeler arası minimum yatay boşluk (sütunlar arası).
        layout.minimumInteritemSpacing = horizontalPadding
        // Satırlar arası minimum dikey boşluk.
        layout.minimumLineSpacing = verticalPadding

        print("Layout parametreleri \(columns) sütun için yapılandırılıyor.")
        // Parametreler ayarlandıktan sonra layout'u GEÇERSİZ KIL.
        // Bu, CollectionView'in bir sonraki layout döngüsünde sizeForItemAt delegate metodunu
        // yeni ayarlarla çağırmasını ve layout'u yeniden hesaplamasını sağlar.
        layout.invalidateLayout()
    }
    
    private func setupInitialUI() {
        [gradientView, darkBottomView, blamePlayerButton, timeAndHintContainer].forEach {
                view.addSubview($0)
        }
    }

    private func setupTimeAndHintUI() {

            timeAndHintContainer.addSubview(hintContainer)
            timeAndHintContainer.addSubview(timeContainer)
        
        if isHintAvailable {
            timeAndHintContainer.addSubview(hintContainer)
            [hintTitle, hintLabel].forEach {
                hintContainer.addSubview($0)
            }
        }
        
        timeContainer.addSubview(timeLabel)

        hintTitle.text = "Örnek Sorular"
        hintTitle.textColor = .white
        hintTitle.textAlignment = .center
        hintTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        hintTitle.translatesAutoresizingMaskIntoConstraints = false

        hintLabel.text = "Brada sigara içmeye izin var mı?"
        hintLabel.textColor = .white
        hintLabel.textAlignment = .center
        hintLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        hintLabel.numberOfLines = 0
        hintLabel.lineBreakMode = .byWordWrapping
        hintLabel.translatesAutoresizingMaskIntoConstraints = false

        timeLabel.text = "2:28"
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 70, weight: .black)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        timeAndHintContainer.translatesAutoresizingMaskIntoConstraints = false
        
        hintContainer.translatesAutoresizingMaskIntoConstraints = false
        timeContainer.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupBottomViewLabelsUI() {
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        darkBottomView.addSubview(topContainer)
        
        findSpyContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(findSpyContainer)
        
        topContainer.backgroundColor = .green
        
        findSpyContainer.addSubview(findSpyTitle)
        findSpyContainer.addSubview(findSpyLabel)
        
        findSpyTitle.text = "Ajanı Bul!"
        findSpyTitle.textColor = .white
        findSpyTitle.textAlignment = .left
        findSpyTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        findSpyTitle.translatesAutoresizingMaskIntoConstraints = false
        
        findSpyLabel.text = "Suçlamak istediğin oyuncuyu seç"
        findSpyLabel.textColor = .spyBlue01
        findSpyLabel.textAlignment = .left
        findSpyLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        findSpyLabel.numberOfLines = 0
        findSpyLabel.lineBreakMode = .byWordWrapping
        findSpyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pointsTitle.text = "OYUNCU 1 SİVVİLDİ"
        pointsTitle.textColor = .white
        pointsTitle.text = pointsTitle.text?.uppercased()
        pointsTitle.textAlignment = .right
        pointsTitle.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        pointsTitle.translatesAutoresizingMaskIntoConstraints = false
        
        civilPointsLabel.text = "Her sivil için -1 puan"
        civilPointsLabel.textColor = .spyBlue01
        civilPointsLabel.textAlignment = .right
        civilPointsLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        civilPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        spyPointsLabel.text = "Ajan için +1 puan"
        spyPointsLabel.textColor = .spyRed01
        spyPointsLabel.textAlignment = .right
        spyPointsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        spyPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pointsContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(pointsContainer)
        pointsContainer.addSubview(pointsTitle)
        pointsContainer.addSubview(civilPointsLabel)
        pointsContainer.addSubview(spyPointsLabel)
        
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        darkBottomView.addSubview(bottomContainer)
        
        bottomContainer.addSubview(bottomLabel)
        bottomLabel.text = "Yanlış suçlama sivillerin alacğı toplam puanı düşürürken ajanınkini arttırır!"
        bottomLabel.textColor = .white
        bottomLabel.textAlignment = .left
        bottomLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        bottomLabel.numberOfLines = 0
        bottomLabel.lineBreakMode = .byWordWrapping
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            timeAndHintContainer.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.bigMargin),
            timeAndHintContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.bigMargin),
            timeAndHintContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.bigMargin),

            timeContainer.leadingAnchor.constraint(
                equalTo: timeAndHintContainer.leadingAnchor),
            timeContainer.trailingAnchor.constraint(
                equalTo: timeAndHintContainer.trailingAnchor),
            timeContainer.topAnchor.constraint(
                equalTo: hintContainer.bottomAnchor),
            timeContainer.bottomAnchor.constraint(
                equalTo: timeAndHintContainer.bottomAnchor),

            timeLabel.leadingAnchor.constraint(
                equalTo: timeAndHintContainer.leadingAnchor),
            timeLabel.trailingAnchor.constraint(
                equalTo: timeAndHintContainer.trailingAnchor),
            timeLabel.centerYAnchor.constraint(
                equalTo: timeContainer.centerYAnchor),

            //
            darkBottomView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.bigMargin),
            darkBottomView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.bigMargin),
            darkBottomView.bottomAnchor.constraint(
                equalTo: blamePlayerButton.topAnchor,
                constant: -Constants.bigMargin),
            darkBottomView.topAnchor.constraint(
                equalTo: timeAndHintContainer.bottomAnchor),
//            darkBottomView.heightAnchor.constraint(
//                equalTo: view.heightAnchor, multiplier: 0.55),
            
            topContainer.leadingAnchor.constraint(
                equalTo: darkBottomView.leadingAnchor, constant: Constants.bigMargin),
            topContainer.trailingAnchor.constraint(
                equalTo: darkBottomView.trailingAnchor, constant: -Constants.bigMargin),
            topContainer.topAnchor.constraint(
                equalTo: darkBottomView.topAnchor, constant: Constants.bigMargin),
            topContainer.heightAnchor.constraint(
                equalTo: view.heightAnchor, multiplier: 0.09),
            
            containerView.leadingAnchor.constraint(
                equalTo: darkBottomView.leadingAnchor, constant: Constants.bigMargin),
            containerView.trailingAnchor.constraint(
                equalTo: darkBottomView.trailingAnchor, constant: -Constants.bigMargin),
            containerView.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor),
            
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            findSpyContainer.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor),
            findSpyContainer.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.4),
            findSpyContainer.topAnchor.constraint(equalTo: topContainer.topAnchor),
            findSpyContainer.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor),
            
            findSpyTitle.leadingAnchor.constraint(equalTo: findSpyContainer.leadingAnchor),
            findSpyTitle.topAnchor.constraint(equalTo: findSpyContainer.topAnchor),
            
            findSpyLabel.leadingAnchor.constraint(equalTo: findSpyContainer.leadingAnchor),
            findSpyLabel.topAnchor.constraint(equalTo: findSpyTitle.bottomAnchor, constant: Constants.littleMargin),
            findSpyLabel.widthAnchor.constraint(equalTo: findSpyContainer.widthAnchor),
            
            pointsContainer.leadingAnchor.constraint(equalTo: findSpyContainer.trailingAnchor),
            pointsContainer.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
            pointsContainer.topAnchor.constraint(equalTo: topContainer.topAnchor),
            pointsContainer.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor),
            
            pointsTitle.trailingAnchor.constraint(equalTo: pointsContainer.trailingAnchor),
            pointsTitle.topAnchor.constraint(equalTo: pointsContainer.topAnchor),
            
            civilPointsLabel.trailingAnchor.constraint(equalTo: pointsContainer.trailingAnchor),
            civilPointsLabel.topAnchor.constraint(equalTo: pointsTitle.bottomAnchor, constant: Constants.littleMargin),
            
            spyPointsLabel.trailingAnchor.constraint(equalTo: pointsContainer.trailingAnchor),
            spyPointsLabel.topAnchor.constraint(equalTo: civilPointsLabel.bottomAnchor, constant: 0),
            
            bottomContainer.leadingAnchor.constraint(
                equalTo: darkBottomView.leadingAnchor, constant: Constants.bigMargin),
            bottomContainer.trailingAnchor.constraint(
                equalTo: darkBottomView.trailingAnchor, constant: -Constants.bigMargin),
            bottomContainer.bottomAnchor.constraint(
                equalTo: darkBottomView.bottomAnchor, constant: -Constants.bigMargin),
            bottomContainer.heightAnchor.constraint(
                equalTo: view.heightAnchor, multiplier: 0.04),
            
            bottomLabel.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor),
            bottomLabel.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor),

            blamePlayerButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.bigMargin),
            blamePlayerButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.bigMargin),
            blamePlayerButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            blamePlayerButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            blamePlayerButton.heightAnchor.constraint(equalToConstant: 60),
        
        ])

        if isHintAvailable {
            hintContainer.leadingAnchor.constraint(
                equalTo: timeAndHintContainer.leadingAnchor).isActive = true
            hintContainer.trailingAnchor.constraint(
                equalTo: timeAndHintContainer.trailingAnchor).isActive = true
            hintContainer.topAnchor.constraint(
                equalTo: timeAndHintContainer.topAnchor).isActive = true
            hintContainer.heightAnchor.constraint(
                equalTo: timeAndHintContainer.heightAnchor, multiplier: 0.3).isActive = true

            hintTitle.leadingAnchor.constraint(
                equalTo: hintContainer.leadingAnchor).isActive = true
            hintTitle.trailingAnchor.constraint(
                equalTo: hintContainer.trailingAnchor).isActive = true
            hintTitle.centerXAnchor.constraint(
                equalTo: hintContainer.centerXAnchor).isActive = true
            hintTitle.topAnchor.constraint(
                equalTo: hintContainer.topAnchor,
                constant: Constants.littleMargin).isActive = true

            hintLabel.widthAnchor.constraint(
                equalTo: hintContainer.widthAnchor, multiplier: 0.9).isActive = true
            hintLabel.topAnchor.constraint(
                equalTo: hintTitle.bottomAnchor,
                constant: Constants.littleMargin).isActive = true
            hintLabel.centerXAnchor.constraint(
                equalTo: hintContainer.centerXAnchor).isActive = true
        } else {
            
        }

        if numberOfChildren < 4 {
            darkBottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        } else {
            darkBottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
        }
        
    }

    private func createBlamePlayerButton() -> CustomGradientButton {
        let button = CustomGradientButton(
            labelText: "Oyuncu Suçla!", width: 100,
            height: GeneralConstants.Button.biggerHeight)
        button.onClick = { [weak self] in
            guard let self = self else { return }
            self.performSegue(
                withIdentifier: "TimerStarttoCountdown", sender: self)
        }
        return button
    }
}

extension CountdownViewController: UICollectionViewDataSource {
    // CollectionView'de gösterilecek toplam öğe sayısı.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Doğrudan numberOfChildren değişkenini döndür.
        return numberOfChildren
    }

    // Belirli bir konum (indexPath) için bir hücre (UICollectionViewCell) oluşturur ve döndürür.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Yeniden kullanılabilir hücre kuyruğundan ChildCollectionViewCell tipinde bir hücre almayı dene.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChildCollectionViewCell.identifier, for: indexPath) as? ChildCollectionViewCell else {
            // Eğer hücre alınamazsa (bu ciddi bir programlama hatasıdır), uygulamayı çökert.
            fatalError("ChildCollectionViewCell dequeue edilemedi")
        }
        // indexPath.item sıfır tabanlı olduğu için +1 ekleyerek çocuk ID'sini al.
        let childId = indexPath.item + 1
        // REMOVED: Original color calculation
        // let color = UIColor(hue: CGFloat(childId % 10) / 10.0, saturation: 0.8, brightness: 0.9, alpha: 1.0)

        // Determine layout based on numberOfChildren
        let isVerticalLayout = (numberOfChildren <= 6)
        // Choose an icon (using a simple example here)
        let iconName = "spy-w"

        // Update cell layout before configuring
        cell.updateLayout(isVertical: isVerticalLayout, numberOfChild: numberOfChildren)

        // --- Selection State Handling ---
        let isSelected = (indexPath == selectedIndex)
        let shrinkTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        let biggerTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        let normalTransform = CGAffineTransform.identity

        let targetColor: UIColor
        let targetTransform: CGAffineTransform

        if isSelected {
            targetColor = .systemRed
            targetTransform = biggerTransform
        } else {
            targetColor = .systemBlue // Default color
            // Shrink if another cell IS selected
            targetTransform = (selectedIndex != nil) ? shrinkTransform : normalTransform
        }

        // Set initial state directly
        cell.transform = targetTransform

        // Hücrenin configure metodunu çağırarak ID, renk ve ikonu ayarla.
        cell.configure(id: childId, color: targetColor, iconName: iconName)
        // Yapılandırılmış hücreyi döndür.
        return cell
    }
}


extension CountdownViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previouslySelectedIndex = selectedIndex // Store previous selection

        if indexPath == selectedIndex { // Tapped already selected cell
            selectedIndex = nil // Deselect
        } else { // Tapped a new cell
            selectedIndex = indexPath // Select the new one
        }

        // Print selection status
        if let selected = selectedIndex {
            print("Selected index: \(selected.item)")
        } else {
            print("Selection cleared")
        }

        // --- Animate changes to visible cells ---
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            for visibleCell in collectionView.visibleCells {
                guard let cell = visibleCell as? ChildCollectionViewCell, // Make sure it's our cell type
                      let indexPathForCell = collectionView.indexPath(for: cell) else { continue }

                let isNowSelected = (indexPathForCell == self.selectedIndex)
                let shrinkTransform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                let biggerTransform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                let normalTransform = CGAffineTransform.identity

                let targetTransform: CGAffineTransform
                let targetColor: UIColor

                if isNowSelected {
                    targetColor = .systemRed
                    targetTransform = biggerTransform
                } else {
                    targetColor = .systemBlue // Default color
                    // Shrink if any cell IS selected
                    targetTransform = (self.selectedIndex != nil) ? shrinkTransform : normalTransform
                }

                cell.transform = targetTransform
                // Update background color directly for animation
                // Assuming configure sets contentView.backgroundColor
                cell.contentView.backgroundColor = targetColor
            }
        }, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
// CollectionView'deki öğelerin layout'u (boyut, boşluk vb.) ile ilgili olayları yönetir.
extension CountdownViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // Layout nesnesini al (UICollectionViewFlowLayout veya alt sınıfı olmalı).
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero // Geçerli layout yoksa sıfır boyut döndür.
        }

        let columns = CGFloat(self.currentColumns)
        let horizontalPadding = layout.minimumInteritemSpacing
        let sectionInsets = layout.sectionInset

        // Öğeler için kullanılabilir toplam yatay genişliği hesapla:
        // CollectionView genişliği - sol kenar boşluğu - sağ kenar boşluğu - (sütunlar arası boşluk sayısı * boşluk genişliği)
        let totalHorizontalPadding = sectionInsets.left + sectionInsets.right + (horizontalPadding * (columns - 1))
        // ÖNEMLİ NOT: collectionView.bounds.width, bu metod çağrıldığında her zaman nihai değeri yansıtmayabilir.
        // viewDidLayoutSubviews içindeki layout geçersiz kılma mekanizması bu sorunu çözmeye yardımcı olur.
        let availableWidth = collectionView.bounds.width - totalHorizontalPadding
        // Her bir öğenin genişliğini hesapla (kullanılabilir genişlik / sütun sayısı).
        // Negatif veya sıfır genişliği önlemek için max(1, ...) kullanılır.
        let itemWidth = max(1, availableWidth / columns)

        // Dinamik öğe yüksekliğini hesapla:
        // 1. O anki durum için gereken toplam satır sayısını hesapla.
        let actualRows = CGFloat((numberOfChildren + Int(columns) - 1) / Int(columns))
        // 2. Layout'tan dikey boşluk ve kenar boşluklarını al.
        let verticalPadding = layout.minimumLineSpacing
        // 3. Toplam dikey boşluğu hesapla: üst kenar + alt kenar + (satırlar arası boşluk sayısı * boşluk yüksekliği).
        let totalVerticalPadding = sectionInsets.top + sectionInsets.bottom + (verticalPadding * (actualRows - 1))
        // 4. Öğeler için kullanılabilir toplam dikey yüksekliği hesapla: CollectionView yüksekliği - toplam dikey boşluk.
        let availableHeight = collectionView.bounds.height - totalVerticalPadding
        // 5. Her bir öğenin yüksekliğini hesapla (kullanılabilir yükseklik / satır sayısı).
        // Negatif veya sıfır yüksekliği önlemek için max(1, ...) kullanılır.
        let itemHeight = max(1, availableHeight / actualRows)

        // Hesaplanan genişlik ve yüksekliği içeren CGSize'ı döndür.
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

struct VCountdownViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            CountdownViewController()
        }
    }
}
