import UIKit

class ParkingMapAssembly {
  func build() -> UIViewController {
    let view = ParkingMapViewController()
    let interactor = ParkingMapInteractor()
    let router = ParkingMapRouter()
    let presenter = ParkingMapPresenter(view: view, interactor: interactor, router: router)

    view.presenter = presenter
    interactor.presenter = presenter
    router.view = view

    return view
  }
}
