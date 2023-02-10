import UIKit

class ParkingMapAssembly {
  func build() -> UIViewController {
    let view = ParkingMapViewController()
    let interactor = ParkingMapInteractor()
    let router = ParkingMapRouter()
    let presenter = ParkingMapPresenter(view: view, interactor: interactor, router: router)
    let parkingSpaceAPI: ParkingSpaceApiProtocol = ParkingSpaceApi()

    view.presenter = presenter
    interactor.presenter = presenter
    interactor.parkingSpaceAPI = parkingSpaceAPI
    router.view = view

    return view
  }
}
