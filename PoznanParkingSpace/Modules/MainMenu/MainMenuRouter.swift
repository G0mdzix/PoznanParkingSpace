import UIKit
import Foundation

class MainMenuRouter {
  weak var view: UIViewController?
}

extension MainMenuRouter: MainMenuRouterProtocol {
  func openParkingMap() {
    let vc = ParkingMapAssembly().build()
    view?.navigationController?.pushViewController(vc, animated: true)
  }
}
