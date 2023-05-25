import UIKit

class ParkingMapAssembly {
  func build() -> UIViewController {
    let view = ParkingMapViewController()
    let interactor = ParkingMapInteractor()
    let router = ParkingMapRouter()
    let presenter = ParkingMapPresenter(view: view, interactor: interactor, router: router)
    let netwrokManager: NetworkManagerListner = NetworkManager()

    view.presenter = presenter
    interactor.presenter = presenter
    interactor.networkManager = netwrokManager
    router.view = view

    return view
  }
}
