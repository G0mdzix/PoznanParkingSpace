import Foundation

// MARK: - View

protocol ParkingMapViewProtocol: AnyObject {
  func displayAnnotations(parkingAnnotationList: [MapAnnotation])
}

// MARK: - Presenter

protocol ParkingMapPresenterProtocol: AnyObject {
  func onViewDidLoad()
  func presentParkingSpaceList(parkingAnnotationList: [MapAnnotation])
}

// MARK: - Interactor

protocol ParkingMapInteractorProtocol: AnyObject {
  func fetchDataFromParkingSpaceAPI()
}

// MARK: - Router

protocol ParkingMapRouterProtocol: AnyObject {
}
