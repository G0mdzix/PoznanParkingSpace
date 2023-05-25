import UIKit

class MainMenuPresenter {

  private let interactor: MainMenuInteractorProtocol
  private let router: MainMenuRouterProtocol
  weak var view: MainMenuViewProtocol?

  var poznanParkingSpaceList: [ParkingSpace]?
  var filteredPoznanParkingSpaceList: [ParkingSpace]?

  init(
    view: MainMenuViewProtocol,
    interactor: MainMenuInteractorProtocol,
    router: MainMenuRouterProtocol
  ) {
    self.interactor = interactor
    self.router = router
    self.view = view
  }
}

extension MainMenuPresenter: MainMenuPresenterProtocol {
  func onSettingOptionsSelected() {
    router.openSettingOptions()
  }

  func getPoznanParkingList(poznanParkingList: [ParkingSpace]) {
    Task {
      self.poznanParkingSpaceList = poznanParkingList
      self.view?.hideLoading()
    }
  }

  func onParkingMapSelected() {
    router.openParkingMap()
  }

  func onFetchPoznanParkingSpaceList() {
    view?.showLoading()
    interactor.fetchPoznanParkingSpace()
  }

  func poznanParkingListItems(at index: Int) -> ParkingSpace? {
    guard let item = poznanParkingSpaceList?[index] else { return nil }
    return item
  }

  func poznanParkingListCount() -> Int {
    guard let poznanParkingSpaceList = poznanParkingSpaceList else { return 0 }
    return poznanParkingSpaceList.count
  }

  func poznanParkingFilteredListItems(at index: Int) -> ParkingSpace? {
    guard let item = filteredPoznanParkingSpaceList?[index] else { return nil }
    return item
  }

  func poznanParkingFilteredListCount() -> Int {
    guard let filteredPoznanParkingSpaceList = filteredPoznanParkingSpaceList else { return 0 }
    return filteredPoznanParkingSpaceList.count
  }

  func filterToSearch(searchText: String) {
    filteredPoznanParkingSpaceList = poznanParkingSpaceList?.filter({
      $0.properties.street.lowercased().contains( searchText.lowercased())
    })
  }
}
