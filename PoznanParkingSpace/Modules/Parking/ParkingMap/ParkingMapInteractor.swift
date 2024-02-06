// swiftlint:disable all

import Foundation
import Combine
import MapKit

class ParkingMapInteractor {

  // MARK: - Properties

  weak var presenter: ParkingMapPresenterProtocol?
  var networkManager: NetworkManagerListner?
  var cancellables = Set<AnyCancellable>()
  private var flaga = false
  var vehicleEstimateResponse: VehicleEstimateResponse.Data? {
    didSet {
      calculateAverageFuelConsumption()
    }
  }
  var selectedLocation: [ParkingSpace] = []
  var mainList: [ParkingSpace] = [] {
    didSet {
      logic()
    }
  }

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
        peka: $0.properties.peka,
        freeSpots: 3
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
        self.mainList = parkingSpaceList.features
        if self.flaga == false {
          self.convertAPIDataToMapAnnotation(parkingSpaceList: parkingSpaceList.features)
        }
      case .failure:
        break // in feature
      }
    }
  }

  func startIteractior(poznanParkingList: [ParkingSpace]) {
    flaga = true
    selectedLocation = poznanParkingList
    convertAPIDataToMapAnnotation(parkingSpaceList: poznanParkingList)
  }
}

// MARK: - ChangeParkSpotLogic

extension ParkingMapInteractor {
  func logic() {
    let selected = makeAnnotationList(
      parkingSpaceList: selectedLocation,
      freeSpots: 4
    )
    var mainListPoznan = makeAnnotationList(
      parkingSpaceList: mainList,
      freeSpots: getRandomNumber()
    )

    mainListPoznan.removeAll { $0.street == selected[0].street }

    searchNearestFreeParkingSpace(
      mainListPoznan: mainListPoznan,
      selectedAnnotation: selected
    )
  }

  private func searchNearestFreeParkingSpace(
    mainListPoznan: [MapAnnotation],
    selectedAnnotation: [MapAnnotation]
  ) {
    guard let selectedAnnotation = selectedAnnotation.first else { return }
    let selectedAnnotationLocation = makeLocation(
      location: selectedAnnotation
    )

    if selectedAnnotation.freeSpots < 5 {
      let closestRealAnnotation = getClosestRealAnnotation(
        closestAnnotations: getClosestAnnotations(
          mainListPoznan: mainListPoznan,
          selectedAnnotationLocation: selectedAnnotationLocation
        ),
        selectedAnnotationLocation: selectedAnnotationLocation
      )

      let closestRealAnnotationnLocation = makeLocation(
        location: closestRealAnnotation
      )
      let distance = selectedAnnotationLocation.distance(
        from: closestRealAnnotationnLocation
      )/1000

      estimateVehicle(
        vehicleMake: Vehicle.mark,
        vehicleModel: Vehicle.type,
        distanceValue: String(distance.rounded(toPlaces: 3)),
        distanceUnit: Vehicle.distanceUnit
      )
      presenter!.removeAllAnnotations()
      presenter!.presentParkingSpaceList(
        parkingAnnotationList: [closestRealAnnotation]
      )
    }
  }

  func calculateAverageFuelConsumption()  {
    guard let response = vehicleEstimateResponse else { return }
    let SavedFuelConsumption = Double(response.co2e_gm!) / PetrolType.diesel

    presenter!.showLabels(
      savedCo2: String(response.co2e_gm ?? 0),
      savedFuel: String(SavedFuelConsumption.rounded(toPlaces: 4)),
      savedDistance: response.distance_value ?? ""
    )
  }

  func makeAnnotationList(parkingSpaceList: [ParkingSpace], freeSpots: Int) -> [MapAnnotation] {
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
        peka: $0.properties.peka,
        freeSpots: freeSpots
      )
      parkingAnnotationList.append(parkingAnnotation)
    }
    return parkingAnnotationList
  }

  private func getRandomNumber() -> Int {
    let randomNumber = Int.random(in: 3...8)
    return randomNumber
  }

  private func getClosestAnnotations(
    mainListPoznan: [MapAnnotation],
    selectedAnnotationLocation: CLLocation
  ) -> [MapAnnotation] {
    return mainListPoznan.filter { annotation in
      let mainListLocation = makeLocation(location: annotation)
        let distance = mainListLocation.distance(from: selectedAnnotationLocation)
        return distance < 800
    }
  }

  private func makeUnwrapMapAnnotation() -> MapAnnotation {
    return MapAnnotation(
      coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
      bilon: "",
      blik: "",
      zone: "",
      street: "",
      card: "",
      peka: "",
      freeSpots: 0
    )
  }

  private func getClosestRealAnnotation(
    closestAnnotations: [MapAnnotation],
    selectedAnnotationLocation: CLLocation
  ) -> MapAnnotation {
    guard let closestAnnotation = closestAnnotations.min(by: { location1, location2 in

      let annotationLocation1 = makeLocation(location: location1)
      let annotationLocation2 = makeLocation(location: location2)

      let distance1 = annotationLocation1.distance(from: selectedAnnotationLocation)
      let distance2 = annotationLocation2.distance(from: selectedAnnotationLocation)
      return distance1 < distance2
    }) else { return makeUnwrapMapAnnotation() }
    return closestAnnotation
  }

  private func makeLocation(location: MapAnnotation) -> CLLocation {
    return CLLocation(
      latitude: location.coordinate.latitude,
      longitude: location.coordinate.longitude
    )
  }

  func estimateVehicle(vehicleMake: String, vehicleModel: String, distanceValue: String, distanceUnit: String) {
      let headers = [
          "content-type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer fQ98oU704xFvsnXcQLVDbpeCJHPglG1DcxiMLKfpeNEMGumlbzVf1lCI6ZBx",
          "X-RapidAPI-Key": "cd517da20dmshbd441c344fb43b6p1f0944jsn36f350580c14",
          "X-RapidAPI-Host": "carbonsutra1.p.rapidapi.com"
      ]

      let postData = NSMutableData(data: "vehicle_make=\(vehicleMake)".data(using: String.Encoding.utf8)!)
      postData.append("&vehicle_model=\(vehicleModel)".data(using: String.Encoding.utf8)!)
      postData.append("&distance_value=\(distanceValue)".data(using: String.Encoding.utf8)!)
      postData.append("&distance_unit=\(distanceUnit)".data(using: String.Encoding.utf8)!)

      let request = NSMutableURLRequest(url: NSURL(string: "https://carbonsutra1.p.rapidapi.com/vehicle_estimate_by_model")! as URL,
                                        cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
      request.httpMethod = "POST"
      request.allHTTPHeaderFields = headers
      request.httpBody = postData as Data

      let session = URLSession.shared
      let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if let error = error {
              print(error)
          } else if let data = data {
              if let httpResponse = response as? HTTPURLResponse {
                  print(httpResponse)
                  if httpResponse.statusCode == 200 {
                      do {
                          let decoder = JSONDecoder()
                          let response = try decoder.decode(VehicleEstimateResponse.self, from: data)
                          if let responseData = response.data {
                            self.vehicleEstimateResponse = responseData
                          } else {
                              print("Invalid response data")
                          }
                      } catch {
                          print("Error decoding response: \(error)")
                      }
                  }
              }
          }
      })

      dataTask.resume()
  }
}

// MARK: - Constants

private enum PetrolType {
  static let diesel: Double = 2640
  static let petrol: Double = 2390
  static let LPG: Double = 1660
  static let CNG: Double = 2666
}

private enum Vehicle {
  static let mark = "Lexus"
  static let type = "RX 300"
  static let distanceUnit = "km"
}
