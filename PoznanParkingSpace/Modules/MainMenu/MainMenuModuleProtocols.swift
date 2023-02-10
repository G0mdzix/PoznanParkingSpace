import Foundation

//  MARK: - View

protocol MainMenuViewProtocol: AnyObject {
}

//  MARK: - Presenter

protocol MainMenuPresenterProtocol: AnyObject {
  func onParkingMapSelected()
}

//  MARK: - Interactor

protocol MainMenuInteractorProtocol: AnyObject {
}

//  MARK: - Router

protocol MainMenuRouterProtocol: AnyObject {
  func openParkingMap()
}
