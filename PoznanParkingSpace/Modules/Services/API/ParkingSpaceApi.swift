import Foundation

class ParkingSpaceApi: ParkingSpaceApiProtocol {
  func getApiData(_ completion: @escaping (ResultType<ParkingSpaceList>) -> Void) {
    guard let sourceURL = K.apiUrl else { return }
    let baseUrlRequest = URLRequest(url: sourceURL)
    let session = URLSession.shared
    session.dataTask(with: baseUrlRequest) { data, _, error in
      guard error == nil else { 
        guard let error = error else { return }
        completion(ResultType.failure(error: error))
        return
      }
      guard let data = data else {
        guard let error = error else { return }
        completion(ResultType.failure(error: error))
        return
      }
      do {
        let jsonFromData = try JSONDecoder().decode(ParkingSpaceList.self, from: data)
          completion(ResultType.success(jsonFromData))
      } catch DecodingError.dataCorrupted(let context) {
        completion(ResultType.failure(error: DecodingError.dataCorrupted(context)))
      } catch let DecodingError.keyNotFound(key, context) {
        completion(ResultType.failure(error: DecodingError.keyNotFound(key, context)))
      } catch let DecodingError.typeMismatch(type, context) {
        completion(ResultType.failure(error: DecodingError.typeMismatch(type, context)))
      } catch let DecodingError.valueNotFound(value, context) {
        completion(ResultType.failure(error: DecodingError.valueNotFound(value, context)))
      } catch {
        completion(ResultType.failure(error: JSONDecodingError.unknownError))
      }
    }
    .resume()
  }
}

private enum K {
  static let apiUrl = URL(
    string: "https://www.poznan.pl/mim/plan/map_service.html?mtype=pub_transport&co=parking_meters"
  )
}

enum ResultType<T> {
  case success(T)
  case failure(error: Error)
}

protocol ParkingSpaceApiProtocol: AnyObject {
  func getApiData(_ completion: @escaping (ResultType<ParkingSpaceList>) -> Void)
}
