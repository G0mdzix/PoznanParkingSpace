// swiftlint:disable all

import Foundation
import MapKit
import CoreLocation

class AutoRouting {

  var shouldStopRouting = false
  var location1: CLLocation?

  func calculateAutoRouting(userCurrentLocation: CLLocation, stationLocation: CLLocation, mapKit: MKMapView) {


    let sourceMapItem = MKMapItem(placemark: MKPlacemark(coordinate: userCurrentLocation.coordinate, addressDictionary: nil))
    let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: stationLocation.coordinate, addressDictionary: nil))

    let directionRequest = MKDirections.Request()
    directionRequest.source = sourceMapItem
    directionRequest.destination = destinationItem
    directionRequest.transportType = .automobile
    directionRequest.requestsAlternateRoutes = true

    let directions = MKDirections(request: directionRequest)

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      directions.calculate { (response, error) in
        guard let response = response, !self.shouldStopRouting else {
          if let error = error {
            //print("ERROR FOUND: \(error.localizedDescription)")
          }
          return
        }
        let route = response.routes[0]

        if !mapKit.overlays.isEmpty {
            mapKit.removeOverlays(mapKit.overlays)
        }
        
        mapKit.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        mapKit.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
      }
    }
  }
}
