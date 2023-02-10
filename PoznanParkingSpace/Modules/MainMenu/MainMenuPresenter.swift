import UIKit

class MainMenuPresenter {

  private let interactor: MainMenuInteractorProtocol
  private let router: MainMenuRouterProtocol
  weak var view: MainMenuViewProtocol?

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
  func onParkingMapSelected() {
    router.openParkingMap()
  }
}
