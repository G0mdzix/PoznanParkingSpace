import Foundation
import UIKit

enum Colors {
  static let transparent = UIColor.white.withAlphaComponent(0.0)
  static let darkturquoise = UIColor(red: 0.00, green: 0.81, blue: 0.82, alpha: 1.00)
  static let mediumturquoise = UIColor(red: 0.28, green: 0.82, blue: 0.80, alpha: 1.00)
  static let turquoise = UIColor(red: 0.25, green: 0.88, blue: 0.82, alpha: 1.00)
  static let paleturquoise = UIColor(red: 0.69, green: 0.93, blue: 0.93, alpha: 1.00)
}

enum Fonts {
  static let defaultBold = UIFont(name: "Montserrat-Bold", size: 24)
  static let tableViewBold = UIFont(name: "Montserrat-Bold", size: 14)
  static let largeDefaultBold = UIFont.boldSystemFont(ofSize: 24)
}
