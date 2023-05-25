import Foundation

protocol NetworkManagerListner: AnyObject {
  func fetchParkingSpaceInIntervals(
    completion: @escaping (NetworkManagerResultType<ParkingSpaceList>) -> Void
  )
  func fetchCarbonSutra(
    completion: @escaping (NetworkManagerResultType<CarbonSutraVehiclesModel>) -> Void
  )
  func fetchAndProcessParkingSpaceData(
    completion: @escaping (Result<ParkingSpaceList, Error>) -> Void
  )
}
