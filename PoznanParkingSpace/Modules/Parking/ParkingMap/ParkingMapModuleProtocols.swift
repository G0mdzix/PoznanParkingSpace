import Foundation

// MARK: - View

protocol ParkingMapViewProtocol: AnyObject {
  func displayAnnotations(parkingAnnotationList: [MapAnnotation])
  func removeAllAnnotations()
  func showLabels(savedCo2: String, savedFuel: String, savedDistance: String) 
}

// MARK: - Presenter

protocol ParkingMapPresenterProtocol: AnyObject {
  func onViewDidLoad()
  func presentParkingSpaceList(parkingAnnotationList: [MapAnnotation])
  func removeAllAnnotations()
  func showLabels(savedCo2: String, savedFuel: String, savedDistance: String)
}

// MARK: - Interactor

protocol ParkingMapInteractorProtocol: AnyObject {
  func fetchDataFromParkingSpaceAPI()
}

// MARK: - Router

protocol ParkingMapRouterProtocol: AnyObject {
}
