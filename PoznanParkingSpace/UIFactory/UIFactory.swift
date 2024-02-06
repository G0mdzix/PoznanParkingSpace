import Foundation
import UIKit
import MapKit

enum UIFactory {
  static func makeBackButton(target: Any?, action: Selector) -> UIButton {
    let button = UIButton(type: .system)
    button.addTarget(target, action: action, for: .touchUpInside)
    button.contentMode = .scaleToFill
    button.clipsToBounds = true
    button.layer.cornerRadius = 20
    button.backgroundColor = AppColorMode.currentMode().secondaryColor
    button.tintColor = AppColorMode.currentMode().mainColor
    button.setImage(UIImage(named: "leftArrow"), for: .normal)
    return button
  }

  static func makeDetectionButton(target: Any?, action: Selector) -> UIButton {
    let button = UIButton(type: .system)
    button.addTarget(target, action: action, for: .touchUpInside)
    button.contentMode = .scaleToFill
    button.clipsToBounds = true
    button.layer.cornerRadius = 23
    button.backgroundColor = AppColorMode.currentMode().secondaryColor
    button.tintColor = AppColorMode.currentMode().mainColor
    button.setImage(UIImage(named: "carIcon"), for: .normal)
    return button
  }

  static func makeMapButton(target: Any?, action: Selector) -> UIButton {
    let button = UIButton(type: .system)
    button.backgroundColor = AppColorMode.currentMode().secondaryColor
    button.tintColor = AppColorMode.currentMode().mainColor
    button.addTarget(target, action: action, for: .touchUpInside)
    button.layer.cornerRadius = Constans.Button.cornerRadius
    button.setTitle("MapButtonText".localized, for: .normal)
    button.setImage(UIImage(named: "mapIcon"), for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    button.titleLabel?.font = Fonts.defaultBold
    return button
  }

  static func makeConfigButton(target: Any?, action: Selector) -> UIButton {
    let button = UIButton(type: .system)
    button.backgroundColor = AppColorMode.currentMode().secondaryColor
    button.tintColor = AppColorMode.currentMode().mainColor
    button.addTarget(target, action: action, for: .touchUpInside)
    button.layer.cornerRadius = button.bounds.height / 2
    button.setImage(UIImage(named: "configIcon"), for: .normal)
    return button
  }

  static func makeMapView() -> MKMapView {
    let mapView = MKMapView()
    mapView.showsUserLocation = true
    return mapView
  }

  static func makePhotoPicker() -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    return picker
  }

  static func makeTableView() -> UITableView {
    let tableView = UITableView()
    tableView.isHidden = false
    tableView.layer.cornerRadius = Constans.Button.cornerRadius
    return tableView
  }

  static func makeStreetSearchBar() -> UISearchBar {
    let searchBar = UISearchBar()
    searchBar.searchBarStyle = UISearchBar.Style.default
    searchBar.searchTextField.attributedPlaceholder = NSAttributedString.init(
      string: "SearchBarTextHolder".localized,
      attributes: [NSAttributedString.Key.foregroundColor: AppColorMode.currentMode().mainColor]
    )
    searchBar.sizeToFit()
    searchBar.isTranslucent = false
    searchBar.backgroundColor = Colors.transparent
    searchBar.barTintColor = Colors.transparent
    searchBar.searchTextField.textColor = AppColorMode.currentMode().mainColor
    searchBar.searchTextField.font = Fonts.tableViewBold

    if let searchIconView = searchBar.searchTextField.leftView as? UIImageView {
      searchIconView.image = searchIconView.image?.withRenderingMode(.alwaysTemplate)
      searchIconView.tintColor = AppColorMode.currentMode().mainColor
    }

    return searchBar
  }

  static func makeLabel() -> UILabel {
    let label = UILabel()
    label.textColor = AppColorMode.currentMode().mainColor
    label.font = Fonts.tableViewBold
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }

  static func makeUIView() -> UIView {
    let view = UIView()
    view.backgroundColor = AppColorMode.currentMode().secondaryColor
    view.layer.cornerRadius = Constans.Button.cornerRadius
    return view
  }
}

// MARK: - Constants

private enum Constans {
  enum Button {
    static let cornerRadius: CGFloat = 8
  }
}
