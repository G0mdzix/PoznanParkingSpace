import UIKit

class ParkingMapAssembly {
  func build(poznanParkingList: [ParkingSpace]) -> UIViewController {
    let view = ParkingMapViewController()
    let interactor = ParkingMapInteractor()
    let router = ParkingMapRouter()
    let presenter = ParkingMapPresenter(view: view, interactor: interactor, router: router)
    let netwrokManager: NetworkManagerListner = NetworkManager()

    view.presenter = presenter
    interactor.presenter = presenter
    interactor.networkManager = netwrokManager
    interactor.startIteractior(poznanParkingList: poznanParkingList)
    router.view = view

    return view
  }
}
