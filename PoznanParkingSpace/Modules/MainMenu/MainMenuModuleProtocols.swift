import Foundation

// MARK: - View

protocol MainMenuViewProtocol: AnyObject {
  func showLoading()
  func hideLoading()
}

// MARK: - Presenter

protocol MainMenuPresenterProtocol: AnyObject {
  func onParkingMapSelected()
  func onSettingOptionsSelected()
  func onFetchPoznanParkingSpaceList()
  func getPoznanParkingList(poznanParkingList: [ParkingSpace])

  func poznanParkingListItems(at index: Int) -> ParkingSpace?
  func poznanParkingListCount() -> Int

  func filterToSearch(searchText: String)

  var filteredPoznanParkingSpaceList: [ParkingSpace]? { get set }
  func poznanParkingFilteredListItems(at index: Int) -> ParkingSpace?
  func poznanParkingFilteredListCount() -> Int
}

// MARK: - Interactor

protocol MainMenuInteractorProtocol: AnyObject {
  func fetchPoznanParkingSpace()
}

// MARK: - Router

protocol MainMenuRouterProtocol: AnyObject {
  func openParkingMap()
  func openSettingOptions()
}
