//
//  Enums.swift
//  Spy
//
//  Created by Zeynep Müslim on 1.04.2025.
//

import UIKit
 
enum ShadowColor {
      case red
      case blue
      case gray
      
      var cgColor: CGColor {
          switch self {
          case .red:
              return UIColor.spyRed01.cgColor
          case .blue:
              return UIColor.spyBlue01.cgColor
          case .gray:
              return UIColor.spyGray01.cgColor
          }
      }
  }

enum ButtonStatus {
    case activeRed
    case activeBlue
    case deactive
    
    var shadowColor: ShadowColor {
        switch self {
        case .activeRed:
            return .red
        case .activeBlue:
            return .blue
        case .deactive:
            return .gray
        }
    }
    
    var gradientColor: GradientColor {
        switch self {
        case .activeRed:
            return .red
        case .activeBlue:
            return .blue
        case .deactive:
            return .gray
        }
    }
}

enum GradientColor {
    case blue
    case red
    case gray
    
    var colors: [CGColor] {
        switch self {
        case .blue:
            return [UIColor.spyBlue01G.cgColor, UIColor.spyBlue02G.cgColor]
        case .red:
            return [UIColor.spyRed01G.cgColor, UIColor.spyRed02G.cgColor]
        case .gray:
            return [UIColor.spyGray01G.cgColor, UIColor.spyGray02G.cgColor]
        }
    }
}
