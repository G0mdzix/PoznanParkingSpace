import UIKit

class ParkingMapPresenter {

  // MARK: - Properties

  private let interactor: ParkingMapInteractorProtocol
  private let router: ParkingMapRouterProtocol
  private let view: ParkingMapViewProtocol

  // MARK: - Lifecycle

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

// MARK: - ParkingMapPresenterProtocol

extension ParkingMapPresenter: ParkingMapPresenterProtocol {
  func showLabels(savedCo2: String, savedFuel: String, savedDistance: String) {
    view.showLabels(savedCo2: savedCo2, savedFuel: savedFuel, savedDistance: savedDistance)
  }

  func onViewDidLoad() {
    interactor.fetchDataFromParkingSpaceAPI()
  }

  func presentParkingSpaceList(parkingAnnotationList: [MapAnnotation]) {
    view.displayAnnotations(parkingAnnotationList: parkingAnnotationList)
  }

  func removeAllAnnotations() {
    view.removeAllAnnotations()
  }
}

// MARK: - PrivateFunctions

extension ParkingMapPresenter {
}

// MARK: - Constants

private enum Constants {
}
