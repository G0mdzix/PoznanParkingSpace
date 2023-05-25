import Foundation

class MainMenuInteractor: MainMenuInteractorProtocol {

  weak var presenter: MainMenuPresenterProtocol?
  var networkManager: NetworkManagerListner?

  func fetchPoznanParkingSpace() {
    guard let networkManager = networkManager else { return }
    networkManager.fetchAndProcessParkingSpaceData { result in
      switch result {
      case .success(let parkingSpaceList):
        self.presenter?.getPoznanParkingList(poznanParkingList: parkingSpaceList.features)
      case .failure(let error):
        break
      }
    }
  }
}
