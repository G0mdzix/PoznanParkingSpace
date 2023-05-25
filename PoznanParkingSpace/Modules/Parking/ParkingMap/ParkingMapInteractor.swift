import Foundation
import Combine
import MapKit

class ParkingMapInteractor {

  // MARK: - Properties

  weak var presenter: ParkingMapPresenterProtocol?
  var networkManager: NetworkManagerListner?

  // MARK: - PrivateFunctions 

  private func convertAPIDataToMapAnnotation(parkingSpaceList: [ParkingSpace]) {
    guard let presenter = presenter else { return }
    var parkingAnnotationList: [MapAnnotation] = []
    parkingSpaceList.forEach {
      let parkingAnnotation = MapAnnotation(
        coordinate: CLLocationCoordinate2D(
          latitude: $0.geometry.coordinates.last ?? 0.0,
          longitude: $0.geometry.coordinates.first ?? 0.0
        ),
        bilon: $0.properties.bilon,
        blik: $0.properties.blik,
        zone: $0.properties.zone,
        street: $0.properties.street,
        card: $0.properties.karta, // TODO 
        peka: $0.properties.peka
      )
      parkingAnnotationList.append(parkingAnnotation)
    }
    presenter.presentParkingSpaceList(parkingAnnotationList: parkingAnnotationList)
  }
}

// MARK: - ParkingMapInteractorProtocol

extension ParkingMapInteractor: ParkingMapInteractorProtocol {
  func fetchDataFromParkingSpaceAPI() {
    guard let networkManager = networkManager else { return }
    networkManager.fetchParkingSpaceInIntervals { resultType in
      switch resultType {
      case .success(let parkingSpaceList):
        print("TEST INTERVALU: ", parkingSpaceList.features.count)
        self.convertAPIDataToMapAnnotation(parkingSpaceList: parkingSpaceList.features)
      case .failure:
        break // in feature
      }
    }
  }

  private func testujemy() {
    guard let networkManager = networkManager else { return }
    networkManager.fetchCarbonSutra { resultType in
      switch resultType {
      case .success(let value):
        print("SPRAWDZAM BMW: ", value.data)
      case .failure:
        break // in feature
      }
    }
  }
}

// MARK: - Constants

private enum Constants {
}
