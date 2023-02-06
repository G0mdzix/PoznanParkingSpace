import UIKit

class ParkingMapPresenter: ParkingMapPresenterProtocol {
  private var interactor: ParkingMapInteractorProtocol
  private var router: ParkingMapRouterProtocol
  weak var view: ParkingMapViewProtocol?

  init(
    view: ParkingMapViewProtocol,
    interactor: ParkingMapInteractorProtocol,
    router: ParkingMapRouterProtocol
  ) {
      self.interactor = interactor
      self.router = router
      self.view = view
  }
}
