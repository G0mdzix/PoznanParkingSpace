import Foundation
import MapKit

class ParkingMapInteractor {

  // MARK: - Properties

  weak var presenter: ParkingMapPresenterProtocol?
  var parkingSpaceAPI: ParkingSpaceApiProtocol?

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
    guard let API = parkingSpaceAPI else { return }
    API.getApiData { results in
      switch results {
      case .success(let value):
        self.convertAPIDataToMapAnnotation(parkingSpaceList: value.features)
      case .failure(let error):
        print(error.localizedDescription) // TODO
      }
    }
  }
}

// MARK: - Constants

private enum Constants {
}
