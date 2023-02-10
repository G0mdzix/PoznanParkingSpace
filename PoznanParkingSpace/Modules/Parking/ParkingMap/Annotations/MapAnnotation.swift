import Foundation
import MapKit

class MapAnnotation: NSObject {
  var coordinate: CLLocationCoordinate2D
  let bilon: String
  let blik: String
  let zone: String
  let street: String
  let card: String
  let peka: String
// TODO - INIT BY PARKINGMODEL STRUCT
  init(
    coordinate: CLLocationCoordinate2D,
    bilon: String,
    blik: String,
    zone: String,
    street: String,
    card: String,
    peka: String
  ) {
    self.coordinate = coordinate
    self.bilon = bilon
    self.blik = blik
    self.zone = zone
    self.street = street
    self.card = card
    self.peka = peka
  }
}

extension MapAnnotation: MKAnnotation {}
