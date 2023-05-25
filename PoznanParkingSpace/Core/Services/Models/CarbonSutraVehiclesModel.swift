import Foundation

struct CarbonSutraVehiclesModel: Codable {
  let data: [CarModel]?
}

struct CarModel: Codable {
  let model: String
}
