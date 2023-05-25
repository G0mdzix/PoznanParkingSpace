import UIKit
import Foundation

class MainMenuRouter {
  weak var view: UIViewController?
}

extension MainMenuRouter: MainMenuRouterProtocol {
  func openSettingOptions() {
    let vc = SettingOptionsAssembly().build()
    view?.present(vc, animated: true)
  }

  func openParkingMap() {
    let vc = ParkingMapAssembly().build()
    view?.navigationController?.pushViewController(vc, animated: true)
  }
}
