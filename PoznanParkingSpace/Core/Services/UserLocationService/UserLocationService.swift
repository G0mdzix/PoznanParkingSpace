import Foundation
import Combine
import CoreLocation

class UserLocationService: NSObject, CLLocationManagerDelegate {
    static let shared = UserLocationService()

    private let locationManager = CLLocationManager()
    private let currentLocationSubject = CurrentValueSubject<CLLocation?, Never>(nil)

    var currentLocationPublisher: AnyPublisher<CLLocation?, Never> {
      return currentLocationSubject.eraseToAnyPublisher()
    }

    private override init() {
      super.init()
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
      locationManager.distanceFilter = kCLDistanceFilterNone
      locationManager.requestAlwaysAuthorization()
      locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        currentLocationSubject.send(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}

