import UIKit

class GameSettingsGroupManager {
    private enum Constants {
        static let minRoundDuration: Int = 1
        static let maxRoundDuration: Int = 10
        static let minRoundCount: Int = 1
        static let maxRoundCount: Int = 10
        static let spacing: CGFloat = GeneralConstants.Layout.spacing
        static let categoryButtonWidth: CGFloat = 90
    }
    
    enum SettingsGroupStyle {
        case plusMinus
        case singleButton
        case switchButton
    }
    
    class SettingsGroup: Equatable {
        let stackView: UIStackView
        let label: VerticalAlignedLabel
        var minusButton: CustomGradientButton?
        var plusButton: CustomGradientButton?
        var actionButton: CustomGradientButton?
        var switchButton: CustomGradientSwitch?
        let valueLabel: UILabel
        
        private var currentValue: Int
        private let minValue: Int
        private let maxValue: Int
        private let valueFormatter: (Int) -> String
        private let buttonColor: GradientColor
        private let buttonShadow: ShadowColor
        private let style: SettingsGroupStyle
//        group1 == group2
        static func == (lhs: GameSettingsGroupManager.SettingsGroup, rhs: GameSettingsGroupManager.SettingsGroup) -> Bool {
            return lhs === rhs
        }
        
        init(title: String,
             target: UIViewController,
             initialValue: Int,
             minValue: Int,
             maxValue: Int,
             style: SettingsGroupStyle = .plusMinus,
             buttonColor: GradientColor = .blue,
             buttonShadow: ShadowColor = .blue,
             valueFormatter: @escaping (Int) -> String,
             actionButtonTitle: String = "") {
            
            self.currentValue = initialValue
            self.minValue = minValue
            self.maxValue = maxValue
            self.valueFormatter = valueFormatter
            self.buttonColor = buttonColor
            self.buttonShadow = buttonShadow
            self.style = style
            
            // Main horizontal stack view
            stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = Constants.spacing
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            // Create vertical stack view for label and value
            let labelStack = UIStackView()
            labelStack.axis = .vertical
            labelStack.spacing = GeneralConstants.Layout.littleSpacing
            labelStack.alignment = .leading
            labelStack.distribution = .fill
            labelStack.translatesAutoresizingMaskIntoConstraints = false
            
            label = VerticalAlignedLabel()
            label.text = title
            label.textColor = .white
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFont(ofSize: GeneralConstants.Font.size04)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            valueLabel = UILabel()
            valueLabel.text = valueFormatter(currentValue)
            valueLabel.textColor = .spyBlue01
            valueLabel.font = UIFont.systemFont(ofSize: GeneralConstants.Font.size02, weight: .regular)
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.textAlignment = .left
            
            labelStack.addArrangedSubview(label)
            if style != .switchButton {
                labelStack.addArrangedSubview(valueLabel)
            }
            
            stackView.addArrangedSubview(labelStack)
            
            let spacerView = UIView()
            spacerView.translatesAutoresizingMaskIntoConstraints = false
            spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            stackView.addArrangedSubview(spacerView)
            
            switch style {
            case .plusMinus:
                minusButton = CustomGradientButton(
                    labelText: "-",
                    gradientColor: buttonColor,
                    width: GeneralConstants.Button.miniHeight,
                    height: GeneralConstants.Button.miniHeight,
                    shadowColor: buttonShadow
                )
                minusButton?.translatesAutoresizingMaskIntoConstraints = false
                
                plusButton = CustomGradientButton(
                    labelText: "+",
                    gradientColor: buttonColor,
                    width: GeneralConstants.Button.miniHeight,
                    height: GeneralConstants.Button.miniHeight,
                    shadowColor: buttonShadow
                )
                plusButton?.translatesAutoresizingMaskIntoConstraints = false
                
                let buttonsStack = UIStackView()
                buttonsStack.axis = .horizontal
                buttonsStack.spacing = Constants.spacing
                buttonsStack.alignment = .center
                buttonsStack.distribution = .fill
                buttonsStack.translatesAutoresizingMaskIntoConstraints = false
                
                if let minus = minusButton, let plus = plusButton {
                    buttonsStack.addArrangedSubview(minus)
                    buttonsStack.addArrangedSubview(plus)
                }
                
                stackView.addArrangedSubview(buttonsStack)
                
                minusButton?.onClick = { [weak self] in
                    self?.decrementValue()
                }
                
                plusButton?.onClick = { [weak self] in
                    self?.incrementValue()
                }
                
            case .singleButton:
                actionButton = CustomGradientButton(
                    labelText: actionButtonTitle,
                    gradientColor: buttonColor,
                    width: Constants.categoryButtonWidth,
                    height: GeneralConstants.Button.miniHeight,
                    shadowColor: buttonShadow,
                    fontSize: GeneralConstants.Font.size01
                )
                actionButton?.translatesAutoresizingMaskIntoConstraints = false
                
                if let action = actionButton {
                    stackView.addArrangedSubview(action)
                }
                
            case .switchButton:
                switchButton = CustomGradientSwitch(gradientColor: .blue, shadowColor: .blue)
                switchButton?.translatesAutoresizingMaskIntoConstraints = false
                switchButton?.isOn = initialValue == 1
                
                if let switchButton = switchButton {
                    stackView.addArrangedSubview(switchButton)
                }
            }
            
            updateButtonStates()
        }
        
        private func incrementValue() {
            guard currentValue < maxValue else { return }
            currentValue += 1
            valueLabel.text = valueFormatter(currentValue)
            updateButtonStates()
        }
        
        private func decrementValue() {
            guard currentValue > minValue else { return }
            currentValue -= 1
            valueLabel.text = valueFormatter(currentValue)
            updateButtonStates()
        }
        
        private func updateButtonStates() {
            guard style == .plusMinus else { return }
            
            if let minus = minusButton {
                updateButton(minus, isEnabled: currentValue > minValue)
            }
            if let plus = plusButton {
                updateButton(plus, isEnabled: currentValue < maxValue)
            }
        }
        
        private func updateButton(_ button: CustomGradientButton, isEnabled: Bool) {
            if isEnabled {
                button.setStatus(buttonColor == .red ? .activeRed : .activeBlue)
                button.isUserInteractionEnabled = true
            } else {
                button.setStatus(.deactive)
                button.isUserInteractionEnabled = false
            }
        }
        
        var value: Int {
            return currentValue
        }
    }
    
    static func createCategoryGroup(target: UIViewController) -> SettingsGroup {
        return SettingsGroup(
            title: "Kategori",
            target: target,
            initialValue: 0,
            minValue: 0,
            maxValue: 0,
            style: .singleButton,
            valueFormatter: { _ in "Temel" },
            actionButtonTitle: "Kategori Seç"
        )
    }
    
    static func createRoundDurationGroup(target: UIViewController) -> SettingsGroup {
        return SettingsGroup(
            title: "Tur Süresi",
            target: target,
            initialValue: 3,
            minValue: Constants.minRoundDuration,
            maxValue: Constants.maxRoundDuration,
            valueFormatter: { value in "\(value) Dakika" }
        )
    }
    
    static func createRoundCountGroup(target: UIViewController) -> SettingsGroup {
        return SettingsGroup(
            title: "Tur Sayısı",
            target: target,
            initialValue: 5,
            minValue: Constants.minRoundCount,
            maxValue: Constants.maxRoundCount,
            valueFormatter: { value in "\(value) Tur" }
        )
    }
    
    static func createHintToggleGroup(target: UIViewController) -> SettingsGroup {
        return SettingsGroup(
            title: "İp ucunu göster",
            target: target,
            initialValue: 1,
            minValue: 0,
            maxValue: 1,
            style: .switchButton,
            valueFormatter: { _ in "" }
        )
    }
} 
