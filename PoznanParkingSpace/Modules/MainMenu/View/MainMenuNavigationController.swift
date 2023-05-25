import Foundation
import UIKit

extension MainMenuViewController {
  func configureNavigationBar(preferredLargeTitle: Bool) {
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.backgroundColor = Colors.darkturquoise
    navBarAppearance.largeTitleTextAttributes = [
      .foregroundColor: AppColorMode.currentMode().secondaryColor,
      .font: Fonts.defaultBold
    ]
    navBarAppearance.titleTextAttributes = [
      .foregroundColor: AppColorMode.currentMode().secondaryColor,
      .font: Fonts.defaultBold
    ]

    navigationController?.navigationBar.standardAppearance = navBarAppearance
    navigationController?.navigationBar.compactAppearance = navBarAppearance
    navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

    navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.tintColor = .black
    navigationItem.title = " Poznan Parking Space"
  }

  func configureItems() {
    let containerView = UIControl(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    containerView.addTarget(self, action: #selector(configButton), for: .touchUpInside)
    let imageSearch = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    imageSearch.image = UIImage(named: "configIcon")
    containerView.addSubview(imageSearch)
    let searchBarButtonItem = UIBarButtonItem(customView: containerView)
    searchBarButtonItem.width = 20
    navigationItem.rightBarButtonItem = searchBarButtonItem
  }

  @objc
  private func configButton() {
    presenter?.onSettingOptionsSelected()
  }
}
