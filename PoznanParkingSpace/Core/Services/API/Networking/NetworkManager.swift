import Foundation
import Combine

class NetworkManager {

  private var cancellables = Set<AnyCancellable>()

  private func fetchAPIData<T: Decodable>(
    model: T.Type,
    urlString: String
  ) -> AnyPublisher<NetworkManagerResultType<T>, Error> {

    let headers = [
      "X-RapidAPI-Key": "cd517da20dmshbd441c344fb43b6p1f0944jsn36f350580c14",
      "X-RapidAPI-Host": "carbonsutra1.p.rapidapi.com"
    ]

    guard let sourceURL = URL(string: urlString) else {
      return Fail(error: URLError(.badURL))
        .map { NetworkManagerResultType.failure(error: $0) }
        .eraseToAnyPublisher()
    }

    var baseUrlRequest = URLRequest(url: sourceURL)
    baseUrlRequest.httpMethod = "GET"
    baseUrlRequest.allHTTPHeaderFields = headers
    let session = URLSession.shared

    return session.dataTaskPublisher(for: baseUrlRequest)
      .tryMap { data, response in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
          throw URLError(.badServerResponse)
        }
        return data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .map { NetworkManagerResultType.success($0) }
      .mapError { error -> Error in
        if let decodingError = error as? DecodingError {
          return decodingError
        } else if let urlError = error as? URLError {
          return urlError
        } else {
          return JSONDecodingError.unknownError
        }
      }
      .eraseToAnyPublisher()
  }
}

extension NetworkManager: NetworkManagerListner {
  func fetchParkingSpaceInIntervals(
    completion: @escaping (NetworkManagerResultType<ParkingSpaceList>) -> Void
  ) {
    Timer.publish(every: 30, tolerance: 1, on: .main, in: .common)
      .autoconnect()
      .flatMap { _ in
        self.fetchParkingSpaceDataPublisher()
      }
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break // in feature
        case .failure(let error):
          break // in feature
        }
      }, receiveValue: { resultType in
        completion(resultType)
      })
      .store(in: &cancellables)
  }

  func fetchCarbonSutra(
    completion: @escaping (NetworkManagerResultType<CarbonSutraVehiclesModel>) -> Void
  ) {
    fetchAPIData(
      model: CarbonSutraVehiclesModel.self,
      urlString: Constants.carbonSutraURLString
    )
    .sink(receiveCompletion: { completion in
      switch completion {
        case .finished:
          break // in feature
      case .failure:
        break // in feature
      }
    }, receiveValue: { resultType in
      completion(resultType)
    })
    .store(in: &cancellables)
  }

  private func fetchParkingSpaceDataPublisher(
  ) -> AnyPublisher<NetworkManagerResultType<ParkingSpaceList>, Error> {
    return fetchAPIData(
      model: ParkingSpaceList.self,
      urlString: Constants.parkingSpaceURLString
    )
  }

  func fetchAndProcessParkingSpaceData(
    completion: @escaping (Result<ParkingSpaceList, Error>) -> Void
  ) {
    fetchParkingSpaceDataPublisher()
      .flatMap { result -> AnyPublisher<ParkingSpaceList, Error> in
        switch result {
        case .success(let parkingSpaceList):
          return Just(parkingSpaceList)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        case .failure(let error):
          return Fail(error: error)
            .eraseToAnyPublisher()
        }
      }
      .sink(receiveCompletion: { completion in
      }, receiveValue: { parkingSpaceList in
        completion(.success(parkingSpaceList))
      })
      .store(in: &cancellables)
  }
}

// MARK: - Constants

private enum Constants {
  static let parkingSpaceURLString =
  "https://www.poznan.pl/mim/plan/map_service.html?mtype=pub_transport&co=parking_meters"
  static let carbonSutraURLString =
  "https://carbonsutra1.p.rapidapi.com/vehicle_makes/bmw/vehicle_models"
}
